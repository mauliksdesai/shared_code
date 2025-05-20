//-------------------------------------------
//  Scoreboard.. Will look at instr input agent 
//  and also look at the output agent and make sure that 
//  the opcodes are going out as expected..
//-------------------------------------------

`ifndef TB_SCOREBOARD_SV
`define TB_SCOREBOARD_SV

class tb_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(tb_scoreboard);
  uvm_analysis_imp #(instr_packet, tb_scoreboard)   instr_imp;
  instr_packet                                      instr_pkt_q[$];

  function new(string name, uvm_component parent);
     super.new(name, parent);
     instr_imp = new("Instr_Input_AP_IMP", this);
  endfunction

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
  endfunction

  function void write(instr_packet pkt);
     `uvm_info(get_name(), $sformatf("Scoreboard saw a Instr Req Packet"), UVM_HIGH)
     if (pkt.opcode == 'b0) begin
        instr_pkt_q.push_back(pkt);
        `uvm_info(get_name(), $sformatf("Input Instruction packet with Load opcode seen by Scoreboard: Outstanding packets = %0d", instr_pkt_q.size()), UVM_HIGH);
     end
  endfunction

  function void write_load(load_packet load);
     `uvm_info(get_name(), $sformatf("Scoreboard saw a Load Req Packet"), UVM_HIGH)
     if (instr_pkt_q.size()) begin 
        instr_pkt_q.pop_front();
        `uvm_info(get_name(), $sformatf("Load Instruction packet with Load opcode seen by Scoreboard: Outstanding packets = %0d", instr_pkt_q.size()), UVM_HIGH)
     end
  endfunction

  function void report_phase(uvm_phase phase); 
     super.report_phase(phase);
     if (instr_pkt_q.size) begin 
        `uvm_error(get_name(), $sformatf("Load Instruction packet Not seen at outputd", instr_pkt_q.size))
     end
     else begin 
        `uvm_info(get_name(), $sformatf("Load Instruction packet with Load opcode seen by Scoreboard: Outstanding packets = %0d", instr_pkt_q.size()), UVM_HIGH)
     end
  endfunction

endclass




`endif

