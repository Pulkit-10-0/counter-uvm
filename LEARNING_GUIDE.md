# Learning guide

Read in this order:

1. `rtl/counter.v`, `counter_if.sv`, and `tb_top.sv`: identify the pins, clock, DUT instance, configuration paths, and `run_test`.
2. `counter_seq_item.svh` and `counter_observation.svh`: compare a requested reset cycle with an observed reset/count pair.
3. `counter_sequence.svh`: follow `send_cycle`, `start_item`, and `finish_item` through the directed scenarios.
4. `counter_sequencer.svh` and `counter_driver.svh`: follow `get_next_item`, falling-edge drive, and `item_done`.
5. `counter_monitor.svh`: see the positive-edge sample, post-NBA delay, and analysis-port write.
6. `counter_scoreboard.svh`: see FIFO `get`, independent prediction, comparison, scenario counters, and phase reports.
7. `counter_agent.svh`, `counter_env.svh`, and `counter_test.svh`: see factory creation, TLM connections, sequence start, and objection lifetime.
8. `counter_pkg.sv`, `build.sh`, and `run.sh`: see source ordering and reproducible execution.

Stimulus flows from sequence to sequencer to driver to interface to DUT. Checking flows from DUT pins through the interface, monitor analysis port, TLM analysis FIFO, and scoreboard. The factory creates UVM classes; `uvm_config_db` supplies the same interface instance to driver and monitor. The driver and monitor each check that lookup.

The driver uses falling-edge assignment and the monitor uses a 1-ps post-rising-edge sample because the DUT writes `count` through a nonblocking assignment. The monitor covergroup measures observed reset/count bins. The scoreboard scenario counters additionally expose rollover and reset-after-counting, while its reference-model comparison judges correctness.
