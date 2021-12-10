////////////////////////////////////////////////////////////////////////////////
// 
// Author: J Reid
// Created: 12/09/2021
// 
// Description:
//     Simple memory interface for testing memory models
//
// Notes:
//     This module was written and simulated to work with Icarus Verilog
//     iverilog -g2012
// 
//     We use seperate parameters for the write and read data to allow using
//     a single interface driving multiple memory models and keeping the 
//     verification of the read data possible
// 
////////////////////////////////////////////////////////////////////////////////
`ifndef uvm_info 
`define uvm_info(lbl, msg) \
$display("[%s] @%t : %s", lbl, $time, msg); 
`endif // uvm_info

`ifndef uvm_error
`define uvm_error(lbl, msg) \
$error("[%s] @%t : %s", lbl, $time, msg); 
`endif // uvm_error

interface mem_ifc #(parameter AWIDTH=16,
                              DWIDTH=16,
                              RWIDTH=16,
                              MDELAY=1)
                   (input clk);

   string             IF_NAME = "Memory";

   logic [RWIDTH-1:0] rdata;
   logic [DWIDTH-1:0] wdata;
   logic [AWIDTH-1:0] addr;
   logic              csn;
   logic              wen;
   logic              msg_en;

   initial begin
      wdata  = '0;
      addr   = '0;
      csn    = 1'b1;
      wen    = 1'b1;
      msg_en = 1'b1;
   end

   // asserts the csn
   task select();
      if( msg_en )
         `uvm_info(IF_NAME, "chip select asserted")
      csn = 1'b0;
   endtask // select

   // deasserts csn
   task deselect();
      if( msg_en )
         `uvm_info(IF_NAME, "chip select deasserted")
      csn = 1'b1;
   endtask // deselect

   // sends a data write
   task write(input [AWIDTH-1:0] d_addr,
              input [DWIDTH-1:0] d_data);
      // we use #1 to emulate clocking blocks 
      @(posedge clk) #1;
      wen   = 1'b0;
      addr  = d_addr;
      wdata = d_data;
      @(posedge clk) #1;
      wen   = 1'b1;
      // display messages on writes 
      if( msg_en ) 
         `uvm_info(IF_NAME, $sformatf("Write 'h%h to address 'h%h complete", d_data, d_addr))
   endtask // write              
   
   // do a data read and verify the read data
   task read(input [AWIDTH-1:0] d_addr,
             input [DWIDTH-1:0] d_data,
             input integer      verify);
      // this is the splice of rdata to compare
      logic [DWIDTH-1:0] rdata_int;

      addr = d_addr;
      #MDELAY;
      if( verify >= 0 )
         rdata_int = rdata[0*verify +: DWIDTH];
      else
         rdata_int = rdata[DWIDTH-1:0];

      // display messages on reads
      if( msg_en )
         `uvm_info(IF_NAME, $sformatf("Reading 'h%h at address 'h%h", rdata_int, d_addr))

      // display messages on verify
      if( verify >= 0 && rdata_int === d_data )
         `uvm_info(IF_NAME, "Data read ok")
      else 
         `uvm_error(IF_NAME, $sformatf("Data mismatch at address 'h%h, Expected: 'h%h, Actual: 'h%h", d_addr, d_data, rdata))
   endtask // read

endinterface // mem_ifc
