// ********************************************************************
//   Agent Config
// ********************************************************************

class instr_agent_cfg extends top_config;
   `uvm_object_utils(instr_agent_cfg);

   virtual instr_intf  vif;

   function new(string name = "instr_agent_config");
      super.new();
   endfunction

endclass
