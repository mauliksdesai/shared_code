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
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);

endclass

function instr_agent::new(string name, uvm_component parent); 
  super.new(name, parent);
  agent_ap = new("instr_agent_ap", this);
endfunction

function void instr_agent::build_phase(uvm_phase phase); 
  super.build_phase(phase);
  `uvm_info(get_name(), $sformatf("Instr Agent : build_phase"), UVM_HIGH)
  if (agt_cfg == null) 
    `uvm_error(get_name(), "Agent doesn't have config set")

  monitor = instr_monitor::type_id::create("instr_monitor", this);
  monitor.vif = agt_cfg.vif;
  if (agt_cfg.get_is_active()) begin
    seqr    = instr_seqr::type_id::create("instr_seqr", this);
    driver  = instr_driver::type_id::create("instr_driver", this);
    driver.vif = agt_cfg.vif;
  end
endfunction

function void instr_agent::connect_phase(uvm_phase phase); 
  super.connect_phase(phase);
  monitor.instr_ap.connect(agent_ap);
  driver.seq_item_port.connect(seqr.seq_item_export);
endfunction

function void instr_agent::report_phase(uvm_phase phase); 
  super.report_phase(phase);
endfunction

task instr_agent::run_phase(uvm_phase phase);
  super.run_phase(phase);
endtask

`endif
