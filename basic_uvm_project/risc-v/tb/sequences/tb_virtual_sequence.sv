// ********************************************************************
// Virtual sequence
//   Virtual sequence is a uvm_object type.. 
//   
//   The sequence would be made from instr_packet type 
//   
//      A Sequence would need to know how many sequence packet would need
//      to be generated.. 
//      It needs to know what sequencer to be using.. 
// ********************************************************************
`ifndef TB_VIRTUAL_SEQUENCE_SV
`define TB_VIRTUAL_SEQUENCE_SV
class tb_virtual_sequence extends uvm_sequence;
   `uvm_object_utils(tb_virtual_sequence);
   `uvm_declare_p_sequencer(tb_virtual_sequencer);

   instr_sequence     instr_seq;
   uvm_event          RESET_DONE = uvm_event_pool::get_global("RESET_DONE");

   function new(string name = "virtual_sequence");
      super.new();
   endfunction

   task pre_start(); 
      if (starting_phase != null) begin 
         starting_phase.raise_objection(this);
      end
   endtask 

   task body(); 
     `uvm_info(get_name(), $sformatf("Virtual sequence body"), UVM_LOW)
      RESET_DONE.wait_trigger();
     `uvm_info(get_name(), $sformatf("Virtual sequence body: RESET_DONE"), UVM_LOW)

     fork 
        `uvm_do_on(instr_seq, p_sequencer.inst_seqr);
     join
   endtask 

   task post_start(); 
      if (starting_phase != null) begin 
         starting_phase.drop_objection(this);
      end
     
   endtask 

endclass
`endif
