 
 module final_mux (
 input [9:0] main_addr,
 input [31:0] a, b, c,
 output [31:0] mux_out
 );
 
 assign mux_out = (main_addr < 512) ? a :
 (main_addr > 511 && main_addr < 576) ? b :
 (main_addr > 575 && main_addr < 640) ? c : 0;
 endmodule
 
 
 
 
