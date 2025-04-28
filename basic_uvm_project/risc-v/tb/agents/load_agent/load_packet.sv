// *****************************************************
//  Load Packet
// *****************************************************
`ifndef LOAD_PACKET_SV
`define LOAD_PACKET_SV

class load_packet extends uvm_sequence_item; 
  `uvm_object_utils(load_packet);

  rand bit       ld_req; 
  rand bit[3:0]  addr;
  rand bit[9:0]  data;
  rand bit       rsp_valid;

  static logic [9:0]    last_data = 0;

  function new(string name = "load_pkt");
     super.new(name);
  endfunction

  function void post_randomize(); 
     last_data = data;
     `uvm_info(get_name(), $sformatf("Post_Randomize: data=%0h, last_data=%0h", data, last_data), UVM_LOW)
  endfunction 

  // constraint c_data {
  //    data dist { 0:=1, 10:=1, 11:=1, 15:=4 };
  // }

  // constraint c_seq_data { 
  //    data == last_data + 1;
  // };

  constraint c_addr_based_data { 
     data == addr + 4;
  };

endclass

`endif
