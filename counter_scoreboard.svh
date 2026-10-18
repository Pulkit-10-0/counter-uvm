class counter_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(counter_scoreboard)
  uvm_tlm_analysis_fifo #(counter_observation) observations;
  bit initialized;
  bit [3:0] expected;
  bit [15:0] values_seen;
  int checks, failures, resets, increments, rollovers, midrun_resets, resumed;
  bit previous_reset, have_counted;
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    observations = new("observations",this);
  endfunction
  task run_phase(uvm_phase phase);
    counter_observation sample;
    forever begin
      observations.get(sample);
      if (!initialized && !sample.reset) continue; // wait for first valid reset edge
      if (sample.reset) begin
        if (have_counted) midrun_resets++;
        expected = 0;
        resets++;
        initialized = 1;
      end else begin
        if (previous_reset && have_counted) resumed++;
        if (expected == 15) rollovers++;
        expected = expected + 4'd1;
        increments++;
        have_counted = 1;
      end
      previous_reset = sample.reset;
      checks++;
      values_seen[sample.count] = 1;
      if (sample.count !== expected) begin
        failures++;
        `uvm_fatal("COUNT_MISMATCH", $sformatf("check %0d reset=%0b expected=%0d actual=%0d",checks,sample.reset,expected,sample.count))
      end
    end
  endtask
  function void check_phase(uvm_phase phase);
    super.check_phase(phase);
    if (checks < 29 || resets < 3 || increments < 20 || rollovers < 1 ||
        midrun_resets < 1 || resumed < 1 || values_seen !== 16'hffff ||
        observations.used() != 0)
      `uvm_fatal("INCOMPLETE", $sformatf("checks=%0d reset=%0d increment=%0d rollover=%0d midrun_reset=%0d resumed=%0d values=%04h fifo=%0d", checks,resets,increments,rollovers,midrun_resets,resumed,values_seen,observations.used()))
  endfunction
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SUMMARY",$sformatf("PASS checks=%0d failures=%0d resets=%0d increments=%0d rollovers=%0d midrun_resets=%0d resumed=%0d values=%04h",checks,failures,resets,increments,rollovers,midrun_resets,resumed,values_seen),UVM_NONE)
  endfunction
endclass
