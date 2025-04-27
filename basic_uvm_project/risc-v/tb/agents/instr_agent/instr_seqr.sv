//*************************************************************************
//  Instruction seqr: 
//     Instruction seqr will get a pointer to interface from config_db
//     Based on that, it will have seqr particular interface and 
//     Make up packets and write to analysis port. This will be 
//     used by scoreboard/checker or other subscribers.. 
//*************************************************************************
`ifndef INSTR_SEQR_SV
`define INSTR_SEQR_SV

class instr_seqr extends uvm_sequencer; 
  `uvm_component_utils(instr_seqr);
  // uvm_analysis_export #(instr_packet)   instr_packet_export;
  // uvm_tlm_analysis_fifo #(input_packet) instr_tlm_analyis_fifo;

  extern function new(string name, uvm_component parent);
  extern function build_phase(uvm_phase phase);
  extern function connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function report_phase(uvm_phase phase);

endclass

function instr_seqr::new(string name, uvm_component parent); 
  super.new(name, parent);
endfunction

function instr_seqr::build_phase(uvm_phase phase); 
  super.build_phase(phase);
  // TODO(Fifo not needed)
  // instr_tlm_analysis_fifo = new("instr_packet_fifo", this);
  // instr_packet_export.connect(instr_tlm_analysis_fifo.analysis_export);
endfunction

function instr_seqr::connect_phase(uvm_phase phase); 
  super.connect_phase(phase);
endfunction

function instr_seqr::report_phase(uvm_phase phase); 
  super.report_phase(phase);
endfunction

task instr_seqr::run_phase(uvm_phase phase);
  super.run_phase(phase);
endtask

`endif
