// Define Interface.. 
//   - Interface should have all inputs/outputs defined as logic
//   - Use Clocking blocks within to define the directions
//   - Clocking Block.
//     - The direction would be from the instance prospective. 
//     - As in A Monitor should have all the traffice defined as inputs

`ifndef INSTR_INTF_SV
`define INSTR_INTF_SV

`define OUTPUT_SKEW 0
`define INPUT_SKEW  0

interface reset_intf(input clk);
  logic                  reset;

  clocking mon_cb @(posedge clk);
    default input #1step output #`OUTPUT_SKEW;
    input                    reset;
  endclocking

  clocking drv_cb @(posedge clk);
    default input #1step output #`OUTPUT_SKEW;
    output                    reset;
  endclocking
endinterface

interface instr_intf(input clk); 
  logic                  valid;
  logic [`REG_WIDTH-1:0] rs0;
  logic [`REG_WIDTH-1:0] rs1;
  logic [`REG_WIDTH-1:0] rd;
  logic [`OP_WIDTH-1:0]  opcode;

  clocking mon_cb @(posedge clk);
    default input #1step output #`OUTPUT_SKEW;
    input                    valid;
    input                    rs0;
    input                    rs1;
    input                    rd;
    input                    opcode;
  endclocking

  clocking drv_cb @(posedge clk);
    default input #1step output #`OUTPUT_SKEW;
    output                   valid;
    output                   rs0;
    output                   rs1;
    output                   rd;
    output                   opcode;
  endclocking

endinterface

`endif
