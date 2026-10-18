`timescale 1ns/1ps
interface counter_if(input logic clk);
  logic reset;
  logic [3:0] count;
endinterface
