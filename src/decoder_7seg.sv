module decoder_7seg (
input logic [3:0] data,
output logic [6:0] hexcode
); 
always@(data) begin
case(data)
4'h0 : hexcode = 7'b1000000; //0 ok
4'h1 : hexcode = 7'b1111001; //1 ok
4'h2 : hexcode = 7'b0100100; //2 ok
4'h3 : hexcode = 7'b0110000; //3 ok
4'h4 : hexcode = 7'b0011001; //4 ok
4'h5 : hexcode = 7'b0010011; //5
4'h6 : hexcode = 7'b0000010; //6 ok
4'h7 : hexcode = 7'b1111000; //7 ok
4'h8 : hexcode = 7'b0000000; //8 ok
4'h9 : hexcode = 7'b0010000; //9 ok
4'hA : hexcode = 7'b0001000; //A ok
4'hB : hexcode = 7'b0000011; //B
4'hC : hexcode = 7'b1000110; //C
4'hD : hexcode = 7'b0100001; //D
4'hE : hexcode = 7'b0000110; //E
4'hF : hexcode = 7'b0001110; //F
default : hexcode = 7'b0000000;
endcase
end 
endmodule		  
								

