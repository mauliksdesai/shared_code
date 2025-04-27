//*************************************************************************
//  Instruction agent: 
//    
//
//*************************************************************************
`ifndef INSTR_AGENT_SV
`define INSTR_AGENT_SV

class instr_agent extends uvm_agent; 
  `uvm_component_utils(instr_agent);

  instr_agent_cfg   agt_cfg;
  instr_driver      driver;
  instr_monitor     monitor;
  instr_seqr        seqr;
  uvm_analysis_port #(instr_packet)  agent_ap;

  extern function new(string name, uvm_component parent);
  extern function build_phase(uvm_phase phase);
  extern function connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function report_phase(uvm_phase phase);

endclass

function instr_agent::new(string name, uvm_component parent); 
  super.new(parent, name);
endfunction

function instr_agent::build_phase(uvm_phase phase); 
  super.build_phase(phase);
  agent_ap = new("instr_agent_ap", this);
  monitor = instr_monitor::type_id::create("instr_monitor", this);
  monitor.vif = agt_cfg.vif;
  if (agt_cfg.get_is_active()) begin
    seqr    = instr_driver::type_id::create("instr_driver", this);
    driver  = instr_driver::type_id::create("instr_driver", this);
    driver.vif = agt_cfg.vif;
  end
endfunction

function instr_agent::connect_phase(uvm_phase phase); 
  super.connect_phase(phase);
  monitor.instr_ap.connect(agent_ap);
  driver.seq_item_port.connect(seqr.seq_item_export);
endfunction

function instr_agent::report_phase(uvm_phase phase); 
  super.report_phase(phase);
endfunction

task instr_agent::run_phase(uvm_phase phase);
  super.run_phase(phase);
endtask

`endif
