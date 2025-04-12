`ifndef RISCV_SV 
`define RISCV_SV 

module riscv #(parameter REG_WIDTH = 5, parameter OP_WIDTH = 7, parameter FIFO_DEPTH = 3) (
      input logic clk, 
      input logic [REG_WIDTH-1:0]  rs0, 
      input logic [REG_WIDTH-1:0]  rs1, 
      input logic [REG_WIDTH-1:0]  rd, 
      input logic [OP_WIDTH-1:0]   opcode, 
      input logic                  valid,
      input logic                  reset,
      
      output logic                  ack,
      output logic [REG_WIDTH-1:0]  rs0_out, 
      output logic [REG_WIDTH-1:0]  rs1_out, 
      output logic [REG_WIDTH-1:0]  rd_out, 
      output logic [OP_WIDTH-1:0]   opcode_out);

  localparam reg_width = REG_WIDTH;
  localparam op_width = OP_WIDTH;
  localparam fifo_depth = FIFO_DEPTH;

  // NOTE: These are unpacked array. 
  logic [REG_WIDTH-1:0]  operand0 [FIFO_DEPTH-1:0];
  logic [REG_WIDTH-1:0]  operand1 [FIFO_DEPTH-1:0];
  logic [REG_WIDTH-1:0]  result   [FIFO_DEPTH-1:0];
  logic [OP_WIDTH-1:0]   operation [FIFO_DEPTH-1:0];
  logic [FIFO_DEPTH-1:0] vld;

  // Difference between always and always_ff/always_comb are following
  // always_ff/always_comb have specific rules enforced: and is sythesisable
  // always_ff would enforce some flip-flop related rules
  always_ff @(posedge clk) begin 
     if (reset)  begin 
        for (int i = 0; i < FIFO_DEPTH; i++) begin 
           operand0[i] = 'b0;
           operand1[i] = 'b0;
           result[i]   = 'b0;
           operation[i]= 'b0;
        end
     end

     if (|vld) begin
        for (int i = FIFO_DEPTH-1; i > 0; i++) begin 
           operand0[i] = operand0[i-1];
           operand1[i] = operand1[i-1];
           result[i]   = result[i-1];
           operation[i]= operation[i-1];
        end
     end
     if (valid) begin 
           operand0[0]  = rs0;
           operand1[0]  = rs1;
           result[0]    = rd;
           operation[0] = opcode;
           vld[0]       = valid;
     end
     else begin 
           operand0[0]  = 'b0;
           operand1[0]  = 'b0;
           result[0]    = 'b0;
           operation[0] = 'b0;
           vld[0]       = 'b0;
     end
  end

  assign ack        = vld[FIFO_DEPTH];
  assign rs0_out    = operand0[FIFO_DEPTH];
  assign rs1_out    = operand0[FIFO_DEPTH];
  assign rd_out     = result[FIFO_DEPTH];
  assign opcode_out = operation[FIFO_DEPTH];

endmodule

`endif
