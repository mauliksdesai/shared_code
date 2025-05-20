RISV-v stimulus generator testbench: 
 
   *  Design will take in an instruction and just pipe it out as a bypass
   *  Two different instances of CPUs 

// Pros and cons of doing this vs. using monitor.. 
// Pros of using this: 
//    Keeps the data paired properly.. 

// Cons: 
//    Only one txn at a time.. Can't put two items in pipe until response comes back..

class my_driver extends uvm_driver #(test_request, test_response); 

   task run_phase(phase); 
      test_request   req;
      test_response  resp;
      forever begin 
         seq_item_port.get_next_item(req); 

         // Process Write which will not have a response back..
         if (req.write) begin 
           vif.drv_cb.write <= req.write;
           vif.drv_cb.addr  <= req.addr;
           vif.drv_cb.data  <= req.data;
           @vif.drv_cb;
           vif.drv_cb.write <= 'b0;
           vif.drv_cb.addr  <= 'b0;
           vif.drv_cb.data  <= 'b0;
           seq_item_port.item_done();
           while (!vif.write_resp_valid) 
              @vif.mon_cb;
           resp = test_response::type_id.create("read_response"); 
           resp.wr_ack = vif.mon_cb.wr_resp_valid; 
           resp.addr = vif.mon_cb.addr; 
         end 
         // process read which will have a response back.. 
         else (req.read) begin
           vif.drv_cb.read <= req.read;
           vif.drv_cb.addr  <= req.addr;
           @vif.drv_cb;
           vif.drv_cb.read <= 'b0;
           vif.drv_cb.addr <= 'b0;
           while (!vif.read_resp_valid) 
              @vif.drv_cb;
           resp = test_response::type_id.create("read_response"); 
           resp.read_resp_valid = vif.mon_cb.read_resp_valid; 
           resp.addr = vif.mon_cb.addr; 
           resp.data = vif.mon_cb.data; 
         end
         seq_item_port.item_done(resp);
      end
   endtask

endclass
