// Sequencer with TLM fifo

`ifndef LOAD_SEQUENCER_SV
`define LOAD_SEQUENCER_SV

class load_req_sequencer extends uvm_sequencer #(load_packet);
   `uvm_component_utils(load_req_sequencer);

   uvm_analysis_export #(load_packet)       load_req_export;
   uvm_tlm_analysis_fifo #(load_packet)     req_fifo;

   function new(string name = "load_rsp_sequencer", uvm_component parent);
      super.new(name, parent);
      req_fifo = new("load_req_fifo", this);
      load_req_export = new("load_request_analysis_export", this);
   endfunction 

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      load_req_export.connect(req_fifo.analysis_export);
   endfunction


endclass



`endif


