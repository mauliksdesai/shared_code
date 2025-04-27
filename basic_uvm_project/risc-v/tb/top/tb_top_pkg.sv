// ***************************************************
//    TB_TOP package
// ***************************************************
// Do not include tb_top.sv here because UVM Packages do not 
// support including of modules
//  This just includes all uvm macros and packages to support
//  building UVM testbench

package tb_top_pkg;
`include "uvm_macros.svh"
import uvm_pkg::*;
`include "tb_top_cfg.sv" 

endpackage
