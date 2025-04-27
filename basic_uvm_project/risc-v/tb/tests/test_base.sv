// UVM TEST
//   Should instantiate env and start the test

`ifndef TEST_BASE_SV
`define TEST_BASE_SV

class test_base extends uvm_test;
   `uvm_component_utils(test_base);

   tb_env      env;
   top_config  top_cfg;
   int         num_instructions;
   uvm_event   RESET_DONE;
   virtual instr_intf  vif;
   virtual reset_intf  r_vif;

   function new(string name = "test_base", uvm_component parent); 
     super.new(name, parent);
     RESET_DONE = uvm_event_pool::get_global("RESET_DONE");
   endfunction

   function void build_phase(uvm_phase phase); 
      super.build_phase(phase);
      env = tb_env::type_id::create("tb_env", this);
      top_cfg = top_config::type_id::create("top_config", this);
      // $value$plusargs("num_instructions", num_instructions);
      // `uvm_info(get_name(), $sformatf("num instructions = %0d", num_instructions), UVM_NONE);
      num_instructions = 20;
      `uvm_info(get_name(), $sformatf("num instructions = %0d", num_instructions), UVM_NONE);
      uvm_config_db#(int)::set(null, "*", "num_instructions", num_instructions);


      uvm_config_db#(virtual instr_intf)::get(null, "*", "input_instr_intf", vif);
      uvm_config_db#(virtual reset_intf)::get(null, "*", "reset_if", r_vif);
      if (vif == null) begin 
         `uvm_error(get_name(), $sformatf("UVM TEST doesn't have vif setup"))
      end
      if (r_vif == null) begin 
         `uvm_error(get_name(), $sformatf("UVM TEST doesn't have r_vif setup"))
      end


   endfunction

   function void connect_phase(uvm_phase phase); 
      super.connect_phase(phase);
   endfunction

   task run_phase(uvm_phase phase);
     super.run_phase(phase);
     phase.raise_objection(this);

     @vif.drv_cb;
     vif.drv_cb.valid <= 0;
     vif.drv_cb.rs0 <= 0;
     vif.drv_cb.rs1 <= 0;
     vif.drv_cb.rd  <= 0;
     vif.drv_cb.opcode  <= 0;
     r_vif.reset <= 0;

     @r_vif.drv_cb;
     r_vif.reset <= 1;

     repeat(2) @r_vif.drv_cb;

     r_vif.reset <= 0;

     repeat(2) @r_vif.drv_cb;
     RESET_DONE.trigger();
     `uvm_info(get_name(), $sformatf("RESET_DONE triggered"), UVM_LOW)
     phase.drop_objection(this);
   endtask

endclass


`endif 
