// Load Slave agent: 
// Instantiate monitor/driver/sequencer

`ifndef LOAD_AGENT_SV
`define LOAD_AGENT_SV

class load_rsp_agent extends uvm_agent;
  `uvm_component_utils(load_rsp_agent);

  load_agent_cfg      load_agt_cfg;
  load_slave_driver   driver;
  load_monitor        monitor;
  load_req_sequencer  seqr; 
  load_sequence       seq;

  uvm_analysis_port  #(load_packet)  agent_ap;

  function new(string name = "load_rsp_agent", uvm_component parent);
     super.new(name, parent);
     agent_ap = new("load_agent_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     monitor = load_monitor::type_id::create("load_monitor", this);
     monitor.vif =  load_agt_cfg.vif;
     if (load_agt_cfg.is_active == UVM_ACTIVE) begin 
        driver = load_slave_driver::type_id::create("load_rsp_driver", this);
        seqr = load_req_sequencer::type_id::create("load_sequencer", this);
        driver.vif = load_agt_cfg.vif;
     end
  endfunction 

  function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
     if (load_agt_cfg.is_active == UVM_ACTIVE) begin 
         monitor.request_ap.connect(seqr.load_req_export);
         driver.seq_item_port.connect(seqr.seq_item_export);
     end
  endfunction

endclass

`endif
 
