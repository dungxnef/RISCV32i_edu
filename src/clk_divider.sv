module clk_divider(
input logic clk_i,
output logic clk_o

);
integer i;
always@(posedge clk_i) begin
i=i+1;
if (i == 10000) begin
i <= 0;
 clk_o <= 1;
 
 end
 else begin
 clk_o <= 0;
 end
end
endmodule