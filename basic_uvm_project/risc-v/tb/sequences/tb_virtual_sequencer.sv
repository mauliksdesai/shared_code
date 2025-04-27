// ********************************************************************
//  Virtual sequencer
//  Virtual Sequencer is just a collection of all the sequencers in the 
//  bench.. That way Virtual Sequence can use it to spawn off all the 
//  sequences
// ********************************************************************

`ifndef TB_VIRTUAL_SEQUENCER
`define TB_VIRTUAL_SEQUENCER

class tb_virtual_sequencer extends uvm_sequencer;
   `uvm_component_utils(tb_virtual_sequencer);

   instr_seqr     inst_seqr;

   function new(string name = "tb_virtual_sequener", uvm_component parent);
     super.new(name, parent); 
   endfunction

   function build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   function connect_phase(uvm_phase phase);
     super.connect_phase(phase);
   endfunction

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
   endtask

endclass
`endif

