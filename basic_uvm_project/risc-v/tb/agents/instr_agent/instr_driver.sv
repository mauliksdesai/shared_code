//*************************************************************************
//  Instruction driver: 
//     Instruction driver will get a pointer to interface from config_db
//     Based on that, it will have driver particular interface and 
//     Make up packets and write to analysis port. This will be 
//     used by scoreboard/checker or other subscribers.. 
//*************************************************************************
`ifndef INSTR_DRIVER_SV
`define INSTR_DRIVER_SV

class instr_driver extends uvm_driver #(instr_packet);
  `uvm_component_utils(instr_driver);

  virtual instr_intf     vif;
  uvm_analysis_export    instr_export;
  bit                    reset_done;
  uvm_event              RESET_DONE;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
  extern task drive_packets();
  
endclass

function instr_driver::new(string name, uvm_component parent); 
  super.new(name, parent);
  RESET_DONE = uvm_event_pool::get_global("RESET_DONE");
endfunction

function void instr_driver::build_phase(uvm_phase phase); 
  super.build_phase(phase);
  if (vif == null) begin 
     `uvm_fatal(get_name(), $sformatf("Virtual interface not provided as expected"))
  end
endfunction

function void instr_driver::connect_phase(uvm_phase phase); 
  super.connect_phase(phase);
endfunction

function void instr_driver::report_phase(uvm_phase phase); 
  super.report_phase(phase);
endfunction

task instr_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  RESET_DONE.wait_trigger();

  fork 
    drive_packets();
  join_none

endtask

task instr_driver::drive_packets();

   repeat(10) @vif.drv_cb;

   forever begin 
     seq_item_port.get_next_item(req);

     // You may have to wait for hop credits before drivig 
     // In otherwords, if the txn has to wait for 
     vif.drv_cb.valid  <= req.valid;
     vif.drv_cb.opcode <= req.opcode;
     vif.drv_cb.rs0    <= req.rs0;
     vif.drv_cb.rs1    <= req.rs1;
     vif.drv_cb.rd     <= req.rd;
     @vif.drv_cb;
     vif.drv_cb.valid  <= 0;
     vif.drv_cb.opcode <= 0;
     vif.drv_cb.rs0    <= 0;
     vif.drv_cb.rs1    <= 0;
     vif.drv_cb.rd     <= 0;
     repeat (req.ipg) @vif.drv_cb;

     seq_item_port.item_done();
   end

endtask

`endif
