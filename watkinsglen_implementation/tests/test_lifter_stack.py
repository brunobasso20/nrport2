"""Compare lifted x86 PUSH instructions with execution of the real opcodes.

Run with Python packages ``capstone`` and ``unicorn`` installed and Luau on PATH,
or set LUAU to its executable path. For example, from the repository root:

    LUAU=/workspace/.nrport2-cloud/bin/luau \
        work/runtime/venv/bin/python watkinsglen_implementation/tests/test_lifter_stack.py

All generated Luau goes into a temporary directory under work/runtime.
"""

from __future__ import annotations

import importlib.util
import os
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import unittest

from unicorn import Uc, UC_ARCH_X86, UC_MODE_32
from unicorn import x86_const as UX


ROOT = Path(__file__).resolve().parents[2]
SPEC = importlib.util.spec_from_file_location(
    "nr2003_stage67_lifter", ROOT / "recovery/stage6_7/lift.py"
)
LIFT = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(LIFT)

BASE = 0x100000
MEMORY_SIZE = 0x10000
CODE_ADDRESS = BASE + 0x1000
STACK_POINTER = BASE + 0x8000
OBSERVED_START = STACK_POINTER - 0x80
OBSERVED_SIZE = 0x100
REGISTERS = {
    "EAX": UX.UC_X86_REG_EAX,
    "EBX": UX.UC_X86_REG_EBX,
    "ECX": UX.UC_X86_REG_ECX,
    "EDX": UX.UC_X86_REG_EDX,
    "ESI": UX.UC_X86_REG_ESI,
    "EDI": UX.UC_X86_REG_EDI,
    "EBP": UX.UC_X86_REG_EBP,
    "ESP": UX.UC_X86_REG_ESP,
}
INITIAL_REGISTERS = {
    "EAX": 0x81234567,
    "EBX": 0xABCDEF01,
    "ECX": 0xFEDCBA98,
    "EDX": 0x76543210,
    "ESI": 0xFFEEDDCC,
    "EDI": 0xAABBCCDD,
    "EBP": STACK_POINTER + 0x40,
    "ESP": STACK_POINTER,
}

# Different neighboring words make an incorrect effective-address order visible.
INITIAL_STACK_WORDS = [
    (0xDA000000 + index * 0x010203) & 0xFFFFFFFF
    for index in range(OBSERVED_SIZE // 4)
]
INITIAL_STACK = struct.pack("<64I", *INITIAL_STACK_WORDS)


def lift_instructions(code: bytes) -> list[str]:
    def read(address: int, size: int) -> bytes:
        offset = address - CODE_ADDRESS
        return code[offset : offset + size]

    lifter = LIFT.Lifter(read, {}, BASE)
    lines = []
    address = CODE_ADDRESS
    while address < CODE_ADDRESS + len(code):
        instruction = lifter.decode(address)
        if instruction.mnemonic != "push":
            raise AssertionError(f"Unexpected opcode: {instruction.mnemonic}")
        emitted, terminates = lifter.inst(instruction, {})
        if terminates:
            raise AssertionError("PUSH unexpectedly terminates the block")
        lines.extend(emitted)
        address += instruction.size
    if address != CODE_ADDRESS + len(code):
        raise AssertionError("Instruction bytes did not decode completely")
    return lines


def execute_x86(code: bytes, initial_registers: dict[str, int]) -> dict[str, list[int]]:
    machine = Uc(UC_ARCH_X86, UC_MODE_32)
    machine.mem_map(BASE, MEMORY_SIZE)
    machine.mem_write(CODE_ADDRESS, code)
    machine.mem_write(OBSERVED_START, INITIAL_STACK)
    for name, value in initial_registers.items():
        machine.reg_write(REGISTERS[name], value)
    machine.emu_start(CODE_ADDRESS, CODE_ADDRESS + len(code), count=100)
    return {
        "registers": [machine.reg_read(register) for register in REGISTERS.values()],
        "stack": list(struct.unpack("<64I", machine.mem_read(OBSERVED_START, OBSERVED_SIZE))),
    }


def execute_luau(
    executable: str, code: bytes, initial_registers: dict[str, int], directory: Path
) -> dict[str, list[int]]:
    lines = [
        "local band, wu, ru = bit32.band, buffer.writeu32, buffer.readu32",
        f"local M = buffer.create({MEMORY_SIZE})",
    ]
    lines.extend(f"local {name} = {value}" for name, value in initial_registers.items())
    lines.extend(
        f"wu(M, {OBSERVED_START - BASE + index * 4}, {value})"
        for index, value in enumerate(INITIAL_STACK_WORDS)
    )
    lines.extend(lift_instructions(code))
    lines.append('print("registers", ' + ", ".join(REGISTERS) + ")")
    lines.extend(
        f'print("stack", ru(M, {OBSERVED_START - BASE + index * 4}))'
        for index in range(len(INITIAL_STACK_WORDS))
    )
    script = directory / "push.luau"
    script.write_text("\n".join(lines) + "\n", encoding="utf-8")
    result = subprocess.run(
        [executable, str(script)], check=True, capture_output=True, text=True, timeout=15
    )
    state: dict[str, list[int]] = {"registers": [], "stack": []}
    for line in result.stdout.splitlines():
        label, *values = line.split()
        state[label].extend(int(value) for value in values)
    return state


class PushSemantics(unittest.TestCase):
    @classmethod
    def setUpClass(cls) -> None:
        cls.luau = os.environ.get("LUAU") or shutil.which("luau")
        if not cls.luau:
            raise RuntimeError("Luau executable missing: set LUAU or add luau to PATH")
        scratch = ROOT / "work/runtime"
        scratch.mkdir(parents=True, exist_ok=True)
        cls.temporary = tempfile.TemporaryDirectory(prefix="lifter-stack-", dir=scratch)
        cls.directory = Path(cls.temporary.name)

    @classmethod
    def tearDownClass(cls) -> None:
        cls.temporary.cleanup()

    def assert_equivalent(self, code: bytes, **register_overrides: int) -> dict[str, list[int]]:
        initial = {**INITIAL_REGISTERS, **register_overrides}
        original = execute_x86(code, initial)
        lifted = execute_luau(self.luau, code, initial, self.directory)
        self.assertEqual(lifted["registers"], original["registers"], "Register state differs")
        self.assertEqual(lifted["stack"], original["stack"], "Stack bytes differ")
        return original

    def test_push_esp_reads_the_pre_decrement_value(self) -> None:
        state = self.assert_equivalent(bytes.fromhex("54"))
        destination = (STACK_POINTER - 4 - OBSERVED_START) // 4
        self.assertEqual(state["stack"][destination], STACK_POINTER)
        self.assertEqual(state["registers"][-1], STACK_POINTER - 4)

    def test_successive_push_esp_values(self) -> None:
        # The second saved pointer must reflect the first completed push.
        state = self.assert_equivalent(bytes.fromhex("54 54 54"))
        for offset in range(3):
            destination = (STACK_POINTER - (offset + 1) * 4 - OBSERVED_START) // 4
            self.assertEqual(state["stack"][destination], STACK_POINTER - offset * 4)

    def test_esp_relative_source_is_read_before_decrement(self) -> None:
        cases = {
            "push dword ptr [esp]": "ff 34 24",
            "push dword ptr [esp + 4]": "ff 74 24 04",
            "push dword ptr [esp - 4]": "ff 74 24 fc",
            "push dword ptr [esp + eax * 4 + 8]": "ff 74 84 08",
        }
        for instruction, encoded in cases.items():
            with self.subTest(instruction=instruction):
                self.assert_equivalent(bytes.fromhex(encoded), EAX=1)

    def test_ordinary_register_pushes(self) -> None:
        # EAX, EBX, ECX, EDX, ESI, EDI, EBP; includes uint32 values above 2**31.
        self.assert_equivalent(bytes.fromhex("50 53 51 52 56 57 55"))

    def test_immediate_pushes(self) -> None:
        self.assert_equivalent(bytes.fromhex("6a ff 6a 00 68 78 56 34 92"))

    def test_by_value_stack_arguments(self) -> None:
        # Iterator/cursor argument pattern: a copied stack value, the saved
        # current stack pointer, another register, then a previous stack value.
        self.assert_equivalent(bytes.fromhex("ff 74 24 08 54 51 ff 74 24 0c"))


if __name__ == "__main__":
    unittest.main(verbosity=2)
