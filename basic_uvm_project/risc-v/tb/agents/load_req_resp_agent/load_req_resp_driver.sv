//********************************************/
// Driver
//********************************************/

class load_req_resp_driver extends uvm_driver #(load_req_resp_packet); 
    `uvm_component_utils(load_req_resp_driver)

    virtual load_intf                       vif;

    function new(string name = "load_req_resp_driver", uvm_component parent);
        super.new(name,parent);
    endfunction 

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (vif == null) 
            `uvm_fatal(get_name(), $sformatf("No Vif"))
    endfunction

    function void connnect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            drive_packets();
        join
    endtask

    task drive_packets();
        forever begin
            seq_item_port.get_next_item(req);
            @vif.drv_cb;
            vif.drv_cb.load_data <= req.ld_req_data;
            vif.drv_cb.data_valid   <= req.ld_data_v;
            @vif.drv_cb;
            vif.drv_cb.load_data <= 'b0;
            vif.drv_cb.data_valid   <= 'b0;
            seq_item_port.item_done();
        end
    endtask

endclass