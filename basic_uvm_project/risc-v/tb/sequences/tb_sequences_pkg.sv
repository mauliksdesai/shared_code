// ********************************************************************
//   Sequences package
//   This should include all active and reactive sequences
//   Should also include top level virutal sequence
// ********************************************************************

package tb_sequences_pkg;
import uvm_pkg::*;
import instr_agent_pkg::*;
`include "uvm_macros.svh"

`include "instr_sequence.sv"
`include "tb_virtual_sequencer.sv"
`include "tb_virtual_sequence.sv"
endpackage

