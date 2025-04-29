//********************************************/
// Agent config
//********************************************/

class load_req_resp_agent_config extends top_config;
    `uvm_object_utils(load_req_resp_agent_config)

    virtual load_intf   vif;

    function new(string name = "load_agent_config");
        super.new(name);
    endfunction

endclass