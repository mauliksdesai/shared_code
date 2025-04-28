// Slave Driver.. Gets a requests from slave_sequencer and drives the data

`ifndef LOAD_SLAVE_DRIVER_SV
`define LOAD_SLAVE_DRIVER_SV

class load_slave_driver extends uvm_driver #(load_packet);
   `uvm_component_utils(load_slave_driver);

   virtual load_intf                       vif;
   uvm_analysis_export                     drv_export;

   function new(string name ="load_slave_driver", uvm_component parent);
      super.new(name, parent);
      // drv_export = new("load_slave_drv_export", this);
   endfunction 

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (vif == null) begin
         `uvm_fatal(get_name(), $sformatf("load_slave_driver does not have vif setup"))
      end
   endfunction

   function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
   endfunction

   task drive_pkts(); 
      forever begin 
         seq_item_port.get_next_item(req);
         `uvm_info(get_name(), $sformatf("Driving Slave Driver: with data = %0h", req.data), UVM_LOW)
         vif.drv_cb.load_data   <= req.data;
         vif.drv_cb.data_valid  <= req.rsp_valid;
         @vif.drv_cb;
         vif.drv_cb.load_data   <= 'b0;
         vif.drv_cb.data_valid  <= 'b0;
         seq_item_port.item_done();
      end
   endtask

   task run_phase(uvm_phase phase);
      super.run_phase(phase);
      fork 
         drive_pkts();
      join
   endtask

endclass


`endif
