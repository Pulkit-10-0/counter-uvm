// A separate type makes actual pin observations distinct from stimulus requests.
class counter_observation extends uvm_sequence_item;
  bit reset;
  bit [3:0] count;
  `uvm_object_utils_begin(counter_observation)
    `uvm_field_int(reset, UVM_ALL_ON)
    `uvm_field_int(count, UVM_ALL_ON)
  `uvm_object_utils_end
  function new(string name="counter_observation");
    super.new(name);
  endfunction
endclass
