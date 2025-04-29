//********************************************/
// Monitor
//********************************************/

class load_req_resp_monitor extends uvm_monitor; 
    `uvm_component_utils(load_req_resp_monitor)

    virtual load_intf                       vif;
    uvm_analysis_port  #(load_req_resp_packet)   ld_req_ap;

    function new(string name = "load_req_resp_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ld_req_ap = new("load_req_ap", this);
        if (vif == null) 
            `uvm_fatal(get_name(), $sformatf("No Vif"))
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
   
    task run_phase(uvm_phase phase); 
        super.run_phase(phase);
        fork 
            monitor_request();
        join
    endtask 

    task monitor_request();
        load_req_resp_packet pkt;
        forever begin 
            while(!vif.mon_cb.load_req) begin
                @vif.mon_cb;
            end
            pkt = load_req_resp_packet::type_id::create("ld_req_packet");
            pkt.ld_req_v = 1'b1;
            pkt.ld_req_addr = vif.mon_cb.load_addr;

            ld_req_ap.write(pkt);
        end
    endtask

endclass