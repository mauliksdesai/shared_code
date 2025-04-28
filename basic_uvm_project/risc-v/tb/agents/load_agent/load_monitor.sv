// Load Monitor.. 
//   It monitors any requests coming in and will generate a tran to sequencer
//   if seen.
//   It will also write the txn to monitor_ap outside for coverage etc..

`ifndef LOAD_MONITOR_SV
`define LOAD_MONITOR_SV

class load_monitor extends uvm_monitor; 
   `uvm_component_utils(load_monitor);

   uvm_analysis_port #(load_packet)    request_ap;
   uvm_analysis_port #(load_packet)    monitor_ap;
   // uvm_tlm_analysis_fifo #(load_packet)   req_tlm_fifo;

   virtual    load_intf                 vif;

   function new(string name = "load_monitor", uvm_component parent);
      super.new(name, parent);
      request_ap = new("ld_req_ap", this);
      monitor_ap = new("ld_mon_ap", this);
   endfunction

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (vif == null) begin 
         `uvm_error(get_name(), $sformatf("Virtual interface not set for Monitor"))
      end
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info(get_name(), $sformatf("Load Monitor run_phase"), UVM_HIGH)
      fork 
         monitor_requests();
      join 
   endtask

   task monitor_requests();
      load_packet load_pkt;
      forever begin
         @vif.mon_cb;

         while(!vif.mon_cb.load_req) 
             @vif.mon_cb;

         load_pkt = load_packet::type_id::create("load_req_pkt");
         load_pkt.ld_req = vif.mon_cb.load_req;
         load_pkt.addr   = vif.mon_cb.load_addr;

         `uvm_info(get_name(), $sformatf("Noticed a Load request: Sending it to slave response agent"), UVM_LOW)
         request_ap.write(load_pkt);
          
      end
   endtask

endclass


`endif

