# 4-bit counter UVM testbench

This project verifies `rtl/counter.v`, an unchanged copy of the original counter RTL. The DUT increments at each rising clock edge, wraps from 15 to 0, and uses active-high synchronous reset. The project was verified with Verilator 5.052 and Accellera IEEE 1800.2-2017-1.0 UVM source.

## Architecture

```text
counter_test → counter_sequence → counter_sequencer → counter_driver
                                               ↓ reset, on falling edge
                                 counter_if → existing counter DUT
                                               ↓ reset/count, after rising edge
counter_scoreboard ← analysis FIFO ← counter_monitor
```

`tb_top.sv` creates the clock, interface, DUT, virtual-interface config entries, and `run_test`. `counter_pkg.sv` imports UVM and includes the classes in dependency order. `counter_if.sv` bundles the pins. `counter_seq_item.svh` carries one requested reset value; `counter_observation.svh` carries the independently sampled pins. `counter_sequence.svh` supplies directed cycles. `counter_sequencer.svh` and `counter_driver.svh` use the standard item handshake. `counter_monitor.svh` publishes actual pin observations. `counter_agent.svh` connects the driver and sequencer. `counter_env.svh` connects the monitor to the scoreboard FIFO. `counter_scoreboard.svh` predicts each count and tracks scenario coverage. `counter_test.svh` starts the sequence and owns the objection.

## Build and run

From this directory:

```sh
./build.sh
./run.sh
```

Compilation output is retained in `build/compile.log`; simulation output is retained in `build/run.log`. `build/obj_dir` holds the generated binary and `build/coverage.dat` holds simulator coverage data. `VERIFICATION_RESULTS.md` records the observed result on this machine. The default RTL is `rtl/counter.v`. By default, `build.sh` looks for the Accellera UVM source in a sibling `learn_uvm2017_sv_verilator/tools/uvm-2017/1800.2-2017-1.0/src` directory. If yours is elsewhere, set `UVM_SRC` to the directory containing `uvm_pkg.sv` before building. For example, `UVM_SRC=/path/to/uvm/src ./build.sh`. `COUNTER_RTL` optionally selects alternate RTL. `build.sh` compiles and elaborates; `run.sh` executes without rebuilding. The UVM source is referenced, not copied into this project.

The summary reports checks, failures, reset edges, increment edges, rollover, mid-operation reset, resumed counting, and the 16-bit mask of observed counter values. UVM errors make a mismatch fail. The checker waits for the first reset edge, then predicts from its own state. It never derives the expected state from `count`. The monitor waits one 1-ps time-precision step after the positive edge to see the DUT's nonblocking update. The driver changes reset on the negative edge, so reset is stable at the sampling edge.

## Coverage and limitations

The monitor samples a SystemVerilog covergroup from actual interface observations. It covers reset, each 4-bit count value, and their cross, and reports its instance coverage. The scoreboard also tracks scenario counters and the observed-value mask; these make rollover and reset-after-counting explicit. Accellera UVM's macro expansion may emit Verilator width warnings. `-Wno-fatal` lets those warnings remain visible in the compile log.

UVM `build_phase` creates components, `connect_phase` wires ports, `run_phase` drives and checks cycles, `check_phase` verifies completion, and `report_phase` prints the summary. Compilation and elaboration are simulator operations, not UVM phases. UVM also defines runtime subphases such as reset, configure, main, and shutdown; this small test uses `run_phase` only.
