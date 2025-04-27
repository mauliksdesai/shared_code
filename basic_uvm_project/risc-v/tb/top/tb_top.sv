`ifndef TB_TOP_SV
`define TB_TOP_SV

// TB Top is supposed to do following: 
//    1. Create an instance of interface and put it in uvm_config_db
//    2. Create instance of the dut and connect interfaces
//    3. Create clock generator
//    4. Kick start uvm_test
//    5. Enable fsdb dumping

module tb_top(); 
   `include "uvm_macros.svh"
   import uvm_pkg::*;              // Import UVM Package

   logic clk;

   initial begin 
      clk = 0; 
      forever begin 
         #10 clk = ~clk;
      end
   end

   instr_intf     input_instr_if(clk);          // Instaniate an instace for input interface
   instr_intf     output_instr_if(clk);         // Instaniate an instace for output interface
   reset_intf     reset_if(clk);

   riscv  #(`FIFO_DEPTH, `REG_WIDTH, `OP_WIDTH) dut (
      .clk        (clk), 
      .valid      (input_instr_if.valid),
      .opcode     (input_instr_if.opcode), 
      .rs0        (input_instr_if.rs0), 
      .rs1        (input_instr_if.rs1), 
      .rd         (input_instr_if.rd), 

      .ack        (output_instr_if.valid), 
      .opcode_out (output_instr_if.opcode), 
      .rs0_out    (output_instr_if.rs0),
      .rs1_out    (output_instr_if.rs1),
      .rd_out     (output_instr_if.rd),

      .reset      (reset_if.reset)
   );

   initial begin 
     run_test();      // if the run_test function is called without any argument, test defined
                      // with +UVM_TESTNAME env variable will be run..
   end

   initial begin
                               // Scope pointer, which is null because it's at highest level
                               // "*" All scope at that level to show 
      uvm_config_db#(virtual instr_intf)::set(null, "*", "input_instr_intf", input_instr_if);
      uvm_config_db#(virtual instr_intf)::set(null, "*", "output_instr_intf", output_instr_if);
      uvm_config_db#(virtual reset_intf)::set(null, "*", "reset_if", reset_if);

      // reset_if.reset = 1'b1;
      // @(posedge clk);
      // reset_if.reset = 1'b0;

      // repeat(5) @(posedge clk);
   end

   initial begin 
     $fsdbDumpfile("tb.fsdb");
     $fsdbDumpvars("+all");
   end

endmodule

`endif
