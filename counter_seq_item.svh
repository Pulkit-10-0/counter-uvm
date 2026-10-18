// One requested clock cycle: the driver applies reset before its rising edge.
class counter_seq_item extends uvm_sequence_item;
  rand bit reset;
  `uvm_object_utils_begin(counter_seq_item)
    `uvm_field_int(reset, UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name="counter_seq_item");
    super.new(name);
  endfunction
endclass
