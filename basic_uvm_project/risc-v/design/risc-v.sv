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
      
      output logic                  ld_req,
      output logic [3:0]            addr,
      input  logic [9:0]            data,
      input  logic                  data_valid,

      output logic                  ack,
      output logic [REG_WIDTH-1:0]  rs0_out, 
      output logic [REG_WIDTH-1:0]  rs1_out, 
      output logic [REG_WIDTH-1:0]  rd_out, 
      output logic [OP_WIDTH-1:0]   opcode_out);

  localparam reg_width = REG_WIDTH;
  localparam op_width = OP_WIDTH;
  localparam fifo_depth = FIFO_DEPTH;

  // NOTE: These are unpacked array. 
  logic [REG_WIDTH-1:0]  operand0;
  logic [REG_WIDTH-1:0]  operand1;
  logic [REG_WIDTH-1:0]  result;
  logic [OP_WIDTH-1:0]   operation;
  logic                  vld;

  logic                  load_req;
  logic [3:0]            load_addr;
  logic [9:0]            load_data;
  logic                  load_data_valid;

  // Difference between always and always_ff/always_comb are following
  // always_ff/always_comb have specific rules enforced: and is sythesisable
  // always_ff would enforce some flip-flop related rules
  always @(posedge clk) begin 
     if (reset)  begin 
        for (int i = 0; i < FIFO_DEPTH; i++) begin 
           operand0[i] = 'b0;
           operand1[i] = 'b0;
           result[i]   = 'b0;
           operation[i]= 'b0;
        end
     end

     if (data_valid) begin
       load_data = data;
       load_data_valid = data_valid;
     end

     if (valid) begin 
           operand0  = rs0;
           operand1  = rs1;
           result    = rd;
           operation = opcode;
           vld       = valid;

           if (opcode == 'b0) begin
              load_req   = 1'b1;
              load_addr  = $urandom_range(0, 3);
           end else
              load_req = 1'b0;
     end
     else begin 
           operand0  = 'b0;
           operand1  = 'b0;
           result   = 'b0;
           operation = 'b0;
           vld       = 'b0;

           load_req    = 'b0;
     end
  end

  assign ack        = vld;
  assign rs0_out    = operand0;
  assign rs1_out    = operand1;
  assign rd_out     = result;
  assign opcode_out = operation;

  assign ld_req     = load_req;
  assign addr       = load_addr;

endmodule

`endif
