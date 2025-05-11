//********************************************/
// Agent
//********************************************/

class load_req_resp_agent extends uvm_agent;
    `uvm_component_utils(load_req_resp_agent)

    load_req_resp_monitor       mon;
    load_req_resp_driver        drv;
    load_req_resp_sequencer     seqr;
    load_req_resp_agent_config  cfg;

    uvm_analysis_port #(load_req_resp_packet)   agent_ap;

    function new(string name = "load_req_resp_agent", uvm_component parent);
        super.new(name, parent);
        agent_ap = new("load_request_agent_ap", this);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (cfg.vif == null)
           `uvm_error(get_name(), $sformatf("No VIF"))

        mon = load_req_resp_monitor::type_id::create("load_req_monitor", this);
        mon.vif = cfg.vif;
        if (cfg.is_active == UVM_ACTIVE)begin
            drv = load_req_resp_driver::type_id::create("load_req_resp_driver", this);
            drv.vif = cfg.vif;
            seqr = load_req_resp_sequencer::type_id::create("load_req_resp_sequencer", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (cfg.is_active == UVM_ACTIVE)begin
            mon.ld_req_ap.connect(agent_ap);
            mon.ld_req_ap.connect(seqr.ld_req_export);
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction

endclass