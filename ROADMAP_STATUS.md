# Roadmap status — após Stage 9

| Stage | Status | O que é verdade agora |
|---|---|---|
| 1. Grafo multibody completo | **DONE** | 16 componentes / 45 estados; no carro em Play via núcleo original gerado. |
| 2. Avaliação de derivadas | **DONE** | Callbacks originais (predictor/solve/corrector/commit) traduzidas e ativas. |
| 3. Restrições e propagação de forças | **DONE** | Solve 005b3180+0055e410 e forças 005b3990 originais ativas. |
| 4. Integrador original | **DONE** | 288 Hz, predictor→forças→corrector→forças→commit na ordem de 005b2190. |
| 5. Substituir integração Roblox do chassi | **DONE + STUDIO VALIDATED** | Modo `NR2003_CORE` preservado intacto como fallback. |
| 6. Suspensão / massas não suspensas / eixo traseiro | **DONE + STUDIO VALIDATED** | Inalterado no Stage 9. |
| 7. Drivetrain completo | **DONE + STUDIO VALIDATED** | Inalterado no Stage 9. |
| 8. Modelo de freio completo | **DONE + STUDIO VALIDATED** (usuário, antes do Stage 9) | Inalterado no Stage 9. |
| 9. Aero completo | **DONE (automático) — pendente validação manual no Studio** | Aero original (`00561a80`/`00561b70`/`00410280`, curvas, estol, dano) agora com entradas reais: sessão `005a3c00` (ρ, vento), fatores por quadro `005637e0`, vácuo `005afd80` (interface; sem outros carros na bancada), fita/aerofólio. Validado contra o original executado (vetores bit a bit, 44 snapshots, 17 cenários). Clima dinâmico `005a4cc0` mapeado e não portado. |
| 10. Setup → runtime | **PARCIAL (não reivindicado)** | Setup padrão do build original; viés de freio (Stage 8) e fita/aerofólio (Stage 9) ajustáveis; carregamento de .sto/garagem completa não feito. |
| 11. Térmica/desgaste/dano/combustível | **NOT DONE** | Congelados nos valores de build. Mapeados no Stage 9: dano aero (`00410910`, exato e validado com dano ≠ 0), fita → térmica do motor (`00554520`→`0051a000`), velocidade do ar `car+0x5aa` → `bf3a00` (térmica de freio/pneu). |
| 12. Cadeia de direção completa | **NOT DONE** | Alvo de roda provisório do host; toe original já aplicado. |
| 13. Torque de direção / FFB | **NOT DONE** | |
| 14. Predição cliente + reconciliação | **NOT DONE** | Servidor autoritativo + interpolação de apresentação (estágio 5). Vácuo multi-carro depende deste estágio (ordem de corrida e posição na pista dos outros carros). |
| 15. Replay determinístico vs NR2003 | **PARCIAL** | Trajetórias do carro completo comparadas contra o código original executado (Unicorn), agora com aero; captura do jogo real ainda não. |

## Carro de referência

NR2003 NASCAR/Cup (série 0, chassis type 2 "spdway", spec `0x7238e0`) com setup padrão do próprio jogo e sessão padrão
das opções de corrida (70 °F, sem vento, condição 0, dia → ρ 1,0812 kg/m³). `TestTune` continua apenas para
`NR2003_CORE`/`ROBLOX_ADAPTER`; `CupTune` só posiciona peças e consultas do host.
