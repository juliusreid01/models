////////////////////////////////////////////////////////////////////////////////
// 
// Author: J Reid
// Created: 12/04/2021
// 
// Description:
//     Parameterized single port memory model
//
// Notes:
//     This module was written and simulated to work with Icarus Verilog
//     iverilog -g2012
// 
////////////////////////////////////////////////////////////////////////////////
module spram #(parameter MEM_DEPTH=16,       // depth of the memory
                         MEM_WIDTH=8,        // width of the memory
                         MEM_DELAY=1)        // internal delay
(input                       clk,    // clock
 output wire [MEM_WIDTH-1:0] rdata,  // read data
 input       [MEM_WIDTH-1:0] wdata,  // write data
 input                       csn,    // chip select - active low
 input                       wen,    // write enable - active low
 input       [MEM_DEPTH-1:0] addr,   // address
 // configuration bits
 input                       mode,   // 0 - read-first, 1 - write-first
 input                       synch); // 0 - asynchronous read, 1 - synchronous read

reg [MEM_DEPTH-1:0][MEM_WIDTH-1:0] mem;        // the internal RAM
reg                [MEM_WIDTH-1:0] rdata_int;  // used for synchronous reads

// this makes the RAM read first
//assign rdata = csn ? 'z : mem[addr];
// this makes the RAM write first
//assign rdata = csn ? 'z : 
//               wen ? mem[addr] : wdata;
// this should do both
assign rdata = csn ? 'z :                      // drive z when csn is high (deasserted)
               ~wen && mode ? wdata :          // write first setting
               synch ? rdata_int : mem[addr];  // read mode

always @(posedge clk) begin
   if( ~wen && ~csn )begin
      mem[addr] <= #MEM_DELAY wdata;
      rdata_int <= mode == 1'b1 ? wdata : mem[addr];
   end
   else
      rdata_int <= mem[addr];
end

endmodule // dpram
