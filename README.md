# MT5 Execution & Risk Control Engine

A modular execution + risk-control foundation for MetaTrader 5 EAs.

This project is **not** a “holy grail strategy”.  
It is an **engineering-focused framework** designed to make automated trading systems more reliable by separating:

- **Strategy layer** (signals only)
- **Execution layer** (orders, fills, state tracking)
- **Risk layer** (drawdown control, kill switch, sizing, safety limits)
- **Logging/Audit layer** (diagnostics and traceability)

## Goals
- Predictable execution behavior in live trading
- Strong capital protection primitives
- Clean architecture, easy to extend
- Portable design (future: replicate the same architecture in NinjaTrader)

## Status
- v0.1.0 planned: project skeleton + risk layer baseline + logging baseline

## Structure
- `src/MQL5/Experts/ExecRiskEngine/` - sample EA wiring the engine
- `src/MQL5/Include/ExecRiskEngine/` - engine modules (.mqh)
- `docs/` - architecture notes

## Disclaimer
For educational and engineering purposes. No performance guarantees.
