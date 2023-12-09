 module output_module (
 input logic clk_o, o_wren,
 input logic [31:0] io_data_in,
 input logic [5:0] o_addr,
 output logic [31:0] io_data_out
 );
 reg[31:0] output_peri[0:63];
 assign io_data_out = (o_wren == 0) ? output_peri[o_addr] : 0;
 always@(posedge clk_o) begin
 if(o_wren)
 begin
 output_peri[o_addr] <= io_data_in;
 end
 end
 endmodule
