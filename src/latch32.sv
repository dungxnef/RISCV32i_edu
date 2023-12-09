module latch32 (
input logic [9:0] address,
input [3:0] hex0_sw, hex1_sw,
output logic [31:0] outs
);
assign outs = (address == 581) ? {28'b0, hex0_sw} : (address == 582) ? {28'b0, hex1_sw} : 32'b0;
endmodule

