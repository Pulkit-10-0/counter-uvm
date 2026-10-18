`timescale 1ns/1ps
module tb_top;
  import uvm_pkg::*;
  import counter_pkg::*;
  bit clk = 0;
  always #5ns clk = ~clk;
  counter_if cif(clk);
  counter dut(.clk(clk),.reset(cif.reset),.count(cif.count));
  initial begin
    cif.reset = 1; // deterministic first edge, before the driver starts
    uvm_config_db#(virtual counter_if)::set(null,"uvm_test_top.env.agent.driver","vif",cif);
    uvm_config_db#(virtual counter_if)::set(null,"uvm_test_top.env.agent.monitor","vif",cif);
    run_test("counter_test");
  end
endmodule
