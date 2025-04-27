// TB ENV: 
//  ENV cerates all agent, virtual sequences, makes connections 

`ifndef TB_ENV_SV
`define TB_ENV_SV

class tb_env extends uvm_env;
  `uvm_component_utils(tb_env);

  virtual instr_intf      input_vif;
  instr_agent_cfg         instr_agt_cfg;
  instr_agent             instr_agt;
  tb_virtual_sequence     v_seq;
  tb_virtual_sequencer    v_seqr;
  uvm_active_passive_enum is_active;

  function new(string name = "tb_env", uvm_component parent);
    super.new();
  endfunction

  function build_phase(uvm_phase phase);
     super.build_phase(phase);

     v_seq            = tb_virtual_sequence::type_id::create("virtual_sequence", this);
     v_seqr           = tb_virtual_sequencer::type_id::create("virtual_sequencer", this);
     instr_agt_cfg    = instr_agent_cfg::type_id::create("input_instr_agent_cfg", this);
     uvm_config_db#(virtual instr_intf)::get(null, "*", input_instr_intf, input_vif);
     instr_agt_cfg.vif  = input_vif;
     instr_agt          = instr_agent::type_id::create("input_instr_agent", this);

  endfunction


  function connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     v_seqr.instr_seqr = instr_agt.instr_seqr;
     // If we were doing a scoreboard, this is where a scoreboard's
     // analysis_export would be connected with agent's analysis_port
  endfunction

  task run_phase(uvm_phase phase); 
    super.run_phase(phase);
    v_seq.starting_phase = phase;
    v_seq.start(v_seqr);
  endtask

  function report_phase(uvm_phase phase);
     super.report_phase(phase);
  endfunction


endclass


`endif

