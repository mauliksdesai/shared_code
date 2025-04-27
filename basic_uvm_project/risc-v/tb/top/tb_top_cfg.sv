// ********************************************************************
//   Top Config
// ********************************************************************
`ifndef TOP_CONFIG_SV
`define TOP_CONFIG_SV

class top_config extends uvm_object;
   `uvm_object_utils(top_config);

   int number_of_instructions = 0; 

   uvm_active_passive_enum is_active = UVM_ACTIVE;
   bit   enable_sb    = 0;
   bit   enable_cov   = 0;


   function new(string name = "top_config");
      super.new();
   endfunction 

   virtual function uvm_active_passive_enum get_is_active();
      return is_active;
   endfunction

   virtual function uvm_active_passive_enum set_is_active(uvm_active_passive_enum active);
      is_active = active;
   endfunction

endclass

`endif
