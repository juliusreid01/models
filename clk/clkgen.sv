////////////////////////////////////////////////////////////////////////////////
// 
// Author: J Reid
// Created: 12/04/2021
// 
// Description:
//     Clock generator module used for testbenches
//
// Notes:
//     This module was written and simulated to work with Icarus Verilog
//     iverilog -g2012
// 
////////////////////////////////////////////////////////////////////////////////
module clkgen #(parameter PERIOD=8)
(output reg clk);  // output clock

logic en;      // clock enable signal

initial begin
   en  = 1'b0;
   clk = 1'bz;
end

always 
   #PERIOD clk = en ? !clk : 1'b0;

task start;
  en = 1'b1;
endtask // start

task stop;
  en = 1'b0;
endtask // stop

endmodule // clkgen
