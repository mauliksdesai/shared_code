//********************************************/
// Packet def
//********************************************/

class load_req_resp_packet extends uvm_sequence_item; 
    `uvm_object_utils(load_req_resp_packet)
    rand bit         ld_req_v;
    rand bit[3:0]    ld_req_addr;
    rand bit[9:0]    ld_req_data;
    rand bit         ld_data_v;

    function new(string name = "load_req_resp_packet");
        super.new(name);
    endfunction

    // Any constraints you may want.. 

endclass