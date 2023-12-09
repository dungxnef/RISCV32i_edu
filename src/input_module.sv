module input_module (
 input logic clk_sw,
 input logic sw_wren,
 input logic [5:0] sw_addr,
 input logic [31:0] sw_data,
 output logic [31:0] sw_out
 );
 
 reg[31:0] sw_mem[0:63];
 assign sw_out = sw_mem[sw_addr];
 
 always@(negedge clk_sw) begin
 sw_mem[sw_addr] <= (sw_wren == 1'b1) ? sw_data : sw_mem[sw_addr];
 end
 endmodule



