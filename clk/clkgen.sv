////////////////////////////////////////////////////////////////////////////////
// 
// Author: J Reid
// Created: 12/04/2021
// 
// Description:
//     Clock generator module used for testbenches
//
// Notes:
// 
////////////////////////////////////////////////////////////////////////////////
module clkgen #(parameter PERIOD=8)
(output clk);  // output clock

logic clkreg;  // clock register
logic en;      // clock enable signal

assign clk = en ? clkreg : 1'bz;

initial begin
   clkreg = 1'bz;

   forever 
      clkreg = #PERIOD ~clkreg;
end

task start;
  en = 1'b1;
endtask // start

task stop;
  en = 1'b0;
endtask // stop

endmodule // clkgen
