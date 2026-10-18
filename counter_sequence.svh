class counter_sequence extends uvm_sequence #(counter_seq_item);
  `uvm_object_utils(counter_sequence)
  function new(string name="counter_sequence");
    super.new(name);
  endfunction
  task send_cycle(bit reset_value);
    counter_seq_item item;
    item = counter_seq_item::type_id::create("item");
    start_item(item);
    item.reset = reset_value;
    finish_item(item);
  endtask
  task body();
    send_cycle(1); // initial reset
    repeat (5) send_cycle(0); // increments
    send_cycle(1); // reset after counting
    repeat (18) send_cycle(0); // resume, visit 0..15, and roll over
    send_cycle(1); // repeated reset
    send_cycle(1); // held reset
    repeat (3) send_cycle(0);
  endtask
endclass
