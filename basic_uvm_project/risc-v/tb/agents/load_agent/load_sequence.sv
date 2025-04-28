// Sequence that looks at the sequencer's analyis fifo and does the needfull..

`ifndef LOAD_SEQUENCE_SV
`define LOAD_SEQUENCE_SV

class load_sequence extends uvm_sequence #(load_packet);
   `uvm_object_utils(load_sequence)
   `uvm_declare_p_sequencer(load_req_sequencer)

   load_packet req_pkt;

   function new(string name = "load_rsp_sequence");
      super.new(name);
   endfunction

   task body(); 
      forever begin 
         p_sequencer.req_fifo.get(req_pkt);
         `uvm_info(get_name(), $sformatf("Sequence got a packet from squencer"), UVM_LOW)
         `uvm_create(req);
         req.randomize() with { ld_req == 0; addr == req_pkt.addr; rsp_valid == 1; };
         `uvm_info(get_name(), $sformatf("Sending addr=%0h, data=%0h to sequencer", req.addr, req.data), UVM_LOW)
         `uvm_send(req);
      end
   endtask

endclass

`endif

