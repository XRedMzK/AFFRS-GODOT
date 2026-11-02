# Night Performance Bench

With the local assets restored, run from the Godot project root. Replace `godot`
with the path to your Godot executable if it is not on `PATH`:

```bash
godot --headless --path . --script res://scripts/perf/NightPerfBench.gd -- --frames=720 --warmup=120
```

Single scenario:

```bash
godot --headless --path . --script res://scripts/perf/NightPerfBench.gd -- --scenario=cctv_map --frames=720 --warmup=120
```

Scenarios:

- `office_idle`
- `office_stress`
- `cctv_map`
- `cctv_disabled`
- `story6_auto`

The bench enables `NightScene`'s internal profiler and prints `PERF_ROW` lines sorted by total time. Headless numbers measure CPU-side script/draw command cost, not real Android GPU time. Use them to find repeatable hot script paths before device profiling.
