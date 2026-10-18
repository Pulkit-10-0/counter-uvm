class counter_test extends uvm_test;
  `uvm_component_utils(counter_test)
  counter_env env;
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = counter_env::type_id::create("env",this);
  endfunction
  task run_phase(uvm_phase phase);
    counter_sequence seq;
    phase.raise_objection(this);
    seq = counter_sequence::type_id::create("sequence");
    seq.start(env.agent.sequencer);
    // Driver acknowledges on the last rising edge; allow its monitor sample
    // and FIFO consumer to finish before UVM enters check_phase.
    @(negedge env.agent.driver.vif.clk);
    phase.drop_objection(this);
  endtask
endclass
