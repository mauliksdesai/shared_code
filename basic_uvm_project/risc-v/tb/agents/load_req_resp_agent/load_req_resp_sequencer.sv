//********************************************/
// Sequencer 
//   This sequencer will also hold a analysis fifo for 
//   a sequence to snoop on and drive the data 
//********************************************/

class load_req_resp_sequencer extends uvm_sequencer #(load_req_resp_packet); 
    `uvm_component_utils(load_req_resp_sequencer)

    uvm_tlm_analysis_fifo   #(load_req_resp_packet)    ld_req_fifo;
    uvm_analysis_export     #(load_req_resp_packet)    ld_req_export;

    function new(string name = "load_req_resp_driver", uvm_component parent);
        super.new(name, parent);
        ld_req_export = new("ld_request_export", this);
        ld_req_fifo   = new("ld_request_fifo", this);
    endfunction 

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ld_req_export.connect(ld_req_fifo.analysis_export);
    endfunction

endclass