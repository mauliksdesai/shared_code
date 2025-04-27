//*************************************************************************
//  Instruction monitor: 
//     Instruction monitor will get a pointer to interface from config_db
//     Based on that, it will have monitor particular interface and 
//     Make up packets and write to analysis port. This will be 
//     used by scoreboard/checker or other subscribers.. 
//*************************************************************************
`ifndef INSTR_MONITOR_SV
`define INSTR_MONITOR_SV

class instr_monitor extends uvm_monitor; 
  `uvm_component_utils(instr_monitor);

  int                  num_packets = 0;
  virtual instr_intf   vif;
  uvm_analysis_port #(instr_packet)   instr_ap;

  extern function new(string name, uvm_component parent);
  extern function build_phase(uvm_phase phase);
  extern function connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function report_phase(uvm_phase phase);

  extern task sample_packets();

endclass

function instr_monitor::new(string name, uvm_component parent); 
  super.new(name, parent);
  instr_ap = new("instr_ap", this);
endfunction

function instr_monitor::build_phase(uvm_phase phase); 
  super.build_phase(phase);
  if (vif == null) begin 
   `uvm_fatal(get_name(), $sformatf("Virtual interface is not setup correctly"))
  end
endfunction

function instr_monitor::connect_phase(uvm_phase phase); 
  super.connect_phase(phase);
  // Nothing needs to be connected here..
endfunction

function instr_monitor::report_phase(uvm_phase phase); 
  super.report_phase(phase);
  `uvm_info(get_name(), $sformatf("Total Transactions seen : %0d", num_packets), UVM_LOW)
endfunction

task instr_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info(get_name(), $sformatf("Run Phase"), UVM_HIGH)
  // The reason you would want to do fork join_none is 
  // to make sure that you could just be done with run_phase and they 
  // are not blocking..
  fork 
    sample_packets();
  join_none 
endtask

task instr_monitor::sample_packets(); 
   instr_packet  instr;
   forever begin 
      @vif.mon_cb;
      while (!vif.mon_cb.valid) 
         @vif.mon_cb;

      instr = instr_packet::type_id::create("instr_pkt");

      instr.valid  = vif.mon_cb.valid;
      instr.rs0    = vif.mon_cb.rs0;
      instr.rs1    = vif.mon_cb.rs1;
      instr.rd     = vif.mon_cb.rd;
      instr.opcode = vif.mon_cb.opcode;
      num_packets++;
      `uvm_info(get_name(), $sformatf("InstrPkt:%0d = %s", num_packets, instr.toString()), UVM_HIGH)
      instr_ap.write(instr);
   end
endtask

`endif
