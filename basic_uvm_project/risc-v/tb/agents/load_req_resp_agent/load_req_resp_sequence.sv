//********************************************/
// Load request response sequence
//********************************************/
class load_req_resp_sequence extends uvm_sequence #(load_req_resp_packet);
    `uvm_object_utils(load_req_resp_sequence)
    `uvm_declare_p_sequencer(load_req_resp_sequencer)

    load_req_resp_packet   pkt;

    function new(string name = "load_req_resp_sequence");
        super.new(name);
    endfunction 

    task body();
        forever begin 
            p_sequencer.ld_req_fifo.get(pkt);
            `uvm_create(req);
            req.randomize() with { ld_req_v == 0; ld_req_addr == pkt.ld_req_addr; ld_data_v == 1; };
            `uvm_send(req);
        end
    endtask

endclass