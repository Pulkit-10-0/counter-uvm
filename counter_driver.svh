class counter_driver extends uvm_driver #(counter_seq_item);
  `uvm_component_utils(counter_driver)
  virtual counter_if vif;
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual counter_if)::get(this,"","vif",vif))
      `uvm_fatal("NO_VIF", "counter_driver needs counter_if")
  endfunction
  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      @(negedge vif.clk); // reset settles half a cycle before DUT samples it
      vif.reset = req.reset;
      @(posedge vif.clk);
      seq_item_port.item_done();
    end
  endtask
endclass
