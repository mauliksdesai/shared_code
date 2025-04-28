// ********************************************************************
//   Agent Config
// ********************************************************************

class load_agent_cfg extends top_config;
   `uvm_object_utils(load_agent_cfg)

   virtual load_intf  vif;

   function new(string name = "load_agent_config");
      super.new();
   endfunction

endclass
