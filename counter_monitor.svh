class counter_monitor extends uvm_monitor;
  `uvm_component_utils(counter_monitor)
  virtual counter_if vif;
  uvm_analysis_port #(counter_observation) observed;
  // Functional coverage samples observed pins, never requested transactions.
  covergroup counter_cg with function sample(bit reset_value, bit [3:0] count_value);
    cp_reset: coverpoint reset_value;
    cp_count: coverpoint count_value { bins each_value[] = {[0:15]}; }
    reset_x_count: cross cp_reset, cp_count;
  endgroup
  function new(string name, uvm_component parent);
    super.new(name,parent);
    observed = new("observed",this);
    counter_cg = new;
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual counter_if)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF", "counter_monitor needs counter_if")
  endfunction
  task run_phase(uvm_phase phase);
    counter_observation sample;
    forever begin
      @(posedge vif.clk);
      // The DUT writes count in the NBA region; 1 ps is the interface time precision.
      // Sampling here observes that edge's settled result, not the previous count.
      #1ps;
      sample = counter_observation::type_id::create("sample");
      sample.reset = vif.reset;
      sample.count = vif.count;
      observed.write(sample);
      counter_cg.sample(sample.reset, sample.count);
    end
  endtask
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COVERAGE", $sformatf("observed covergroup=%0.1f%%",counter_cg.get_inst_coverage()), UVM_NONE)
  endfunction
endclass
