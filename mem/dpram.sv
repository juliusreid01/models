////////////////////////////////////////////////////////////////////////////////
// 
// Author: J Reid
// Created: 12/04/2021
// 
// Description:
//     Parameterized dual port memory model
//
// Notes:
//     This module was written and simulated to work with Icarus Verilog
//     iverilog -g2012
// 
////////////////////////////////////////////////////////////////////////////////
module dpram #(parameter MEM_DEPTH=16, // depth of the memory
                         MEM_WIDTH=8,  // width of the memory
                         MEM_DELAY=1)  // internal delay
(input                        clka,     // port a clock
 output logic [MEM_WIDTH-1:0] rdataa,   // port a read data
 input        [MEM_WIDTH-1:0] wdataa,   // port a write data
 input                        csna,     // port a chip select - active low
 input                        wena,     // port a write enable - active low
 input        [MEM_DEPTH-1:0] addra,    // port a address
 input                        modea,    // port a mode - 0: read first, 1: write first
 input                        syncha,   // port a synch - 0: asynchronous read, 1: synchronous read

 input                        clkb,     // port b clock
 output logic [MEM_WIDTH-1:0] rdatab,   // port b read data
 input        [MEM_WIDTH-1:0] wdatab,   // port b write data
 input                        csnb,     // port b chip select - active low
 input                        wenb,     // port b write enable - active low
 input        [MEM_DEPTH-1:0] addrb,    // port b address
 input                        modeb,    // port a mode - 0: read first, 1: write first
 input                        synchb);  // port a synch - 0: asynchronous read, 1: synchronous read

logic [MEM_DEPTH-1:0][MEM_WIDTH-1:0] mem ;
logic [MEM_DEPTH-1:0][MEM_WIDTH-1:0] mema;
logic [MEM_DEPTH-1:0][MEM_WIDTH-1:0] memb;

logic                [MEM_WIDTH-1:0] rdataa_int;  // used for synchronous reads
logic                [MEM_WIDTH-1:0] rdatab_int;  // used for synchronous reads

assign rdataa = csna ? 'z :                        // drive z when csn is high (deasserted)
                ~wena && modea ? wdataa :          // write first setting
                syncha ? rdataa_int : mem[addra];   // read mode
assign rdatab = csnb ? 'z :                        // drive z when csn is high (deasserted) 
                ~wenb && modeb ? wdatab :          // write first setting
                synchb ? rdatab_int : mem[addrb];   // read mode

// port a write, synchronous read
always @(posedge clka)
   if( ~wena && ~csna )begin
      mema[addra] <= wdataa;
      rdataa_int  <= modea == 1'b1 ? wdataa : mem[addra];
   end
   else
      rdataa_int  <= mem[addra];

// port b write, synchronous read
always @(posedge clkb)
   if( ~wenb && ~csnb )begin
      memb[addrb] <= wdatab;
      rdatab_int  <= modeb == 1'b1 ? wdatab : mem[addrb];
   end
   else
      rdatab_int  <= mem[addrb];

// using a latch to store in mem variable
always_latch begin 
   if( ~wena && ~csna )
      mem[addra] <= mema[addra];
   if( ~wenb && ~csnb )
      mem[addrb] <= memb[addrb];
end

// assert not writing the same address
// icarus does not like this
//assert (~wena && ~wenb && ~csna && ~csnb && addra != addrb )
//else $error("Address A equal Address B during write");
always @*
   if( ~wena && ~wenb && ~csna && ~csnb && addra == addrb )
      $error("Address A equal Address B during write");

endmodule // dpram
