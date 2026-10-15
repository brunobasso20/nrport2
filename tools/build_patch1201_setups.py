"""Build a narrow Studio update for official-patch Watkins Glen presets."""
from pathlib import Path
import json
import subprocess
from xml.sax.saxutils import escape

ROOT = Path(__file__).resolve().parents[1]
OLD_REF = "e949f5db1a58508999721cd8bca75c8af20408c4"


def fnv(text):
    value = 2166136261
    for byte in text.encode():
        value = ((value ^ byte) * 16777619) & 0xffffffff
    return value


def literal(text):
    eq = "="
    while "]" + eq + "]" in text:
        eq += "="
    return "[" + eq + "[\n" + text + "]" + eq + "]"


def main():
    fingerprint = json.loads((ROOT / "recovery/patch1201/evidence/studio_source_fingerprints.json").read_text())
    old = lambda path: subprocess.check_output(["git", "show", f"{OLD_REF}:{path}"], cwd=ROOT).decode().replace("\r\n", "\n")
    entries = [
        ("setup", "modules", "NR2003WatkinsGlenSetup", "ModuleScript", "roblox/NR2003WatkinsGlenSetup.lua", old("roblox/NR2003WatkinsGlenSetup.lua")),
        ("controls", "modules", "SetupTestControls", "ModuleScript", "roblox/SetupTestControls.lua", None),
        ("bindings", "starter", "NR2003SetupTestBindings", "LocalScript", "roblox/SetupTestBindings.client.lua", None),
        ("prediction", "modules", "PredictionServer", "ModuleScript", "roblox/PredictionServer.lua", fingerprint["prediction_server"]),
        ("legacy", "servers", "NR2003Server", "Script", "roblox/Server.server.lua", old("roblox/Server.server.lua")),
    ]
    definitions, manifest = [], []
    for ident, parent, name, cls, path, baseline in entries:
        text = (ROOT / path).read_text()
        old_len, old_hash = ((baseline["bytes"], baseline["fnv"]) if isinstance(baseline, dict)
            else (len(baseline.encode()), fnv(baseline)) if baseline is not None else (0, 0))
        definitions.append("{" + f'id="{ident}",parent={parent},name="{name}",class="{cls}",oldLen={old_len},oldHash={old_hash},source=' + literal(text) + "},")
        manifest.append(dict(id=ident,path=path,old_bytes=old_len,old_fnv=old_hash,new_bytes=len(text.encode()),new_fnv=fnv(text)))
    apply = (ROOT / "recovery/patch1201/installer_template.luau").read_text().replace("-- @SOURCES@", "\n".join(definitions))
    rollback = (ROOT / "recovery/patch1201/rollback_template.luau").read_text()
    (ROOT / "PATCH_NR2003_1201_SETUPS.lua").write_text(apply + "apply()\n")
    (ROOT / "PATCH_NR2003_1201_SETUPS_ROLLBACK.lua").write_text(rollback)
    xml = ('<roblox version="4"><Item class="ModuleScript" referent="RBX0"><Properties>'
        '<string name="Name">NR2003_Patch1201Setups</string><ProtectedString name="Source">'
        + escape(apply + "return apply\n") + '</ProtectedString></Properties></Item></roblox>\n')
    (ROOT / "NR2003_Patch1201Setups.rbxmx").write_text(xml)
    (ROOT / "recovery/patch1201/evidence/studio_installer_sources.json").write_text(json.dumps(manifest,indent=2)+"\n")
    print("Built preset + K / , Studio installer and rollback")


if __name__ == "__main__":
    main()
