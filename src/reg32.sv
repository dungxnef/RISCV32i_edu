module reg32 (
 input logic clk_reg,
 input logic rstn_reg,
 input logic reg_we,
 input logic [9:0] operand_a, operand_b,
 input [31:0] reg_in,
 output [31:0] reg_out
 );
 
 always_ff@(posedge clk_reg,negedge rstn_reg)
 begin
 if (!rstn_reg) 
 begin
 reg_out <= 0;
 end
 else begin
 if ((reg_we) && (operand_a >= operand_b) && ((operand_a) <= (operand_b + 9))) 
 begin
 reg_out <= reg_in;
 end
 //else if (!((reg_we) && (operand_a >= operand_b) && ((operand_a) <= (operand_b + 9)))) 
 //begin
 //reg_out = 0;
 //end
 end
 end
 endmodule
 

