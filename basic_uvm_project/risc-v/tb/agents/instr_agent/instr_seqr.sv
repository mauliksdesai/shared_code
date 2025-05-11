//*************************************************************************
//  Instruction seqr: 
//     Instruction seqr will get a pointer to interface from config_db
//     Based on that, it will have seqr particular interface and 
//     Make up packets and write to analysis port. This will be 
//     used by scoreboard/checker or other subscribers.. 
//*************************************************************************
`ifndef INSTR_SEQR_SV
`define INSTR_SEQR_SV

class instr_seqr extends uvm_sequencer #(instr_packet); 
  `uvm_component_utils(instr_seqr);

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass

function instr_seqr::new(string name, uvm_component parent); 
  super.new(name, parent);
endfunction

function void instr_seqr::build_phase(uvm_phase phase); 
  super.build_phase(phase);
endfunction

function void instr_seqr::connect_phase(uvm_phase phase); 
  super.connect_phase(phase);
endfunction

function void instr_seqr::report_phase(uvm_phase phase); 
  super.report_phase(phase);
endfunction

task instr_seqr::run_phase(uvm_phase phase);
  super.run_phase(phase);
endtask

`endif
