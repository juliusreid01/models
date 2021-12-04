////////////////////////////////////////////////////////////////////////////////
// 
// Author: J Reid
// Created: 12/04/2021
// 
// Description:
//     Reset generator module used for testbenches
//
// Notes:
// 
////////////////////////////////////////////////////////////////////////////////
module rstgen #(parameter ACTIVE_HIGH=1)
(output logic rst);

initial
   rst = ~ACTIVE_HIGH;

task reset(input time delay = 100ns);
   rst = ACTIVE_HIGH;
   #delay;
   rst = ~ACTIVE_HIGH;
endtask // reset

endmodule // rstgen
