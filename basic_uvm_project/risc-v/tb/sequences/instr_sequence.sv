// ********************************************************************
// instr_sequence
//   This would be an active sequence that would generate number of 
//   instructions to be driven into the DUT through instr_sequencer/driver
//   
//   The sequence would be made from instr_packet type 
//   
//      A Sequence would need to know how many sequence packet would need
//      to be generated.. 
//      It needs to know what sequencer to be using.. 
// ********************************************************************
`ifndef INSTR_SEQUENCE_SV
`define INSTR_SEQUENCE_SV
class instr_sequence extends uvm_sequence #(instr_packet);
  `uvm_object_utils(instr_sequence);

  uvm_event       RESET_DONE;
  int             num_instructions;
  int             num_txn_sent = 0;

  function new(string name = "instr_sequence");
    super.new();
    uvm_config_db#(int)::get(null, "*", "num_instructions", num_instructions);
    `uvm_info(get_name(), $sformatf("Number of instructions that will be driven will be %0d", num_instructions), UVM_HIGH)
    RESET_DONE = uvm_event_pool::get_global("RESET_DONE");
  endfunction

  extern task pre_start();         // Pre-start is called before body
  extern task body();
  extern task post_start();        // Post-start is called after body


endclass

task instr_sequence::pre_start();
  super.pre_start();
  if (starting_phase != null) begin 
     starting_phase.raise_objection(this);
     `uvm_info(get_name(), $sformatf("Raised Exception"), UVM_HIGH)
  end

endtask

task instr_sequence::body();
   `uvm_info(get_name(), $sformatf("Entering Body"), UVM_HIGH)

   repeat(num_instructions) begin 
     `uvm_create(req);
     // req.constraint_mode() etc.. 
     req.randomize() with { valid == 1'b1; };
     num_txn_sent++;
     `uvm_info(get_name(), $sformatf("Rand Instr Generated: %0d : %s ", num_txn_sent, req.toString()), UVM_HIGH)
     `uvm_send(req);
   end
   
endtask

task instr_sequence::post_start();
  super.post_start();
  if (starting_phase != null) begin 
     starting_phase.drop_objection(this);
     `uvm_info(get_name(), $sformatf("Dropping Exception"), UVM_HIGH)
  end
endtask


`endif
