// ********************************************************************
//  UVM Sequence item
// ********************************************************************

class instr_packet extends uvm_sequence_item; 
   `uvm_object_utils(instr_packet);

   rand bit                     valid;
   rand bit [`REG_WIDTH-1:0]    rs0;
   rand bit [`REG_WIDTH-1:0]    rs1;
   rand bit [`REG_WIDTH-1:0]    rd;
   rand bit [`OP_WIDTH-1:0]     opcode;

   rand int                     ipg;
   string                       msg;

   function new(string name);
      super.new(name); 
   endfunction: new

   function string toString();
      msg = $sformatf("OPCODE=%0d : RS0=%0d, RS1=%0d, RD=%0d");
   endfunction

   constraint delay_c { 
      ipg dist { 0:=10, [2:4]:=80, [10:15]:=10 };
   };

endclass
