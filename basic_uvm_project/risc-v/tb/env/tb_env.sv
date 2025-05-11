// TB ENV: 
//  ENV cerates all agent, virtual sequences, makes connections 

`ifndef TB_ENV_SV
`define TB_ENV_SV

class tb_env extends uvm_env;
  `uvm_component_utils(tb_env);

  virtual load_intf       load_vif;
  virtual instr_intf      input_vif;
  instr_agent_cfg         instr_agt_cfg;
  instr_agent             instr_agt;

  load_agent_cfg          load_agt_cfg;
  load_rsp_agent          load_agt;

  tb_virtual_sequence     v_seq;
  tb_virtual_sequencer    v_seqr;
  uvm_active_passive_enum is_active;
  uvm_factory factory;
  tb_scoreboard           scoreboard;

  function new(string name = "tb_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  // virtual function void raise_objection(uvm_phase phase, string description = "");
  //    super.raise_objection(phase, description);
  //    `uvm_info(get_name(), $sformatf("Raising objection: phase=%s", phase), UVM_HIGH);
  // endfunction

  // virtual function void drop_objection(uvm_phase phase, string description = "");
  //    super.drop_objection(phase, description);
  //    `uvm_info(get_name(), $sformatf("Dropping objection: phase=%s", phase), UVM_HIGH);
  // endfunction

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);

     scoreboard       = tb_scoreboard::type_id::create("tb_scoreboard", this);
     v_seq            = tb_virtual_sequence::type_id::create("virtual_sequence", this);
     v_seqr           = tb_virtual_sequencer::type_id::create("virtual_sequencer", this);
     instr_agt_cfg    = instr_agent_cfg::type_id::create("input_instr_agent_cfg", this);
     uvm_config_db#(virtual instr_intf)::get(null, "*", "input_instr_intf", input_vif);
     uvm_config_db#(instr_agent_cfg)::set(null, "*", "input_instr_agt_cfg", instr_agt_cfg);

     load_agt_cfg     = load_agent_cfg::type_id::create("load_req_agent_cfg", this);
     uvm_config_db#(virtual load_intf)::get(null, "*", "load_rsp_if", load_vif);
     load_agt_cfg.vif  = load_vif;
     load_agt         = load_rsp_agent::type_id::create("load_req_agent", this);
     load_agt.load_agt_cfg = load_agt_cfg;

     instr_agt_cfg.vif  = input_vif;
     instr_agt          = instr_agent::type_id::create("input_instr_agent", this);
     instr_agt.agt_cfg  = instr_agt_cfg;
     if (instr_agt == null) begin 
       `uvm_error(get_name(), $sformatf("Instr agent is null in build_phase"))
     end
     factory = uvm_factory::get();
     `uvm_info(get_name(), $sformatf("printing uvm_factory"), UVM_NONE)
     factory.print();
     `uvm_info(get_name(), $sformatf("printing uvm_topology"), UVM_NONE)
     uvm_top.print_topology();

  endfunction


  function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     if (instr_agt == null) begin 
       `uvm_error(get_name(), $sformatf("Instr agent is null in connect_phase"))
     end
     if (instr_agt.seqr == null) begin 
       `uvm_error(get_name(), $sformatf("Instr agent seqr is null in connect_phase"))
     end
     v_seqr.inst_seqr = instr_agt.seqr;
     v_seqr.load_req_seqr = load_agt.seqr;

     instr_agt.agent_ap.connect(scoreboard.instr_imp);
     // load_agt.agent_ap.connect(scoreboard.load_imp);

     // TODO(maulikd) load_agt.driver.drv_export.connect()
     // If we were doing a scoreboard, this is where a scoreboard's
     // analysis_export would be connected with agent's analysis_port
  endfunction

  task run_phase(uvm_phase phase); 
    super.run_phase(phase);
    v_seq.starting_phase = phase;
    `uvm_info(get_name(), $sformatf("TB ENV: v_seq starting_phase = %s", v_seq.starting_phase.get_name()), UVM_LOW)
    v_seq.start(v_seqr);
  endtask

  function void report_phase(uvm_phase phase);
     uvm_root roooot;
     super.report_phase(phase);
     roooot = uvm_root::get();
     `uvm_info(get_name(), $sformatf("PRINTING UVM_ROOT"), UVM_HIGH)
     roooot.print();
  endfunction

endclass


`endif

