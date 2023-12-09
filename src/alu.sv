module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
        logic [31:0] diff;
        logic [31:0] udiff;
        logic [31:0] sub_signed;
  	logic [31:0] sub_unsigned;
  	logic slt;
  	logic sltu;
  	logic sge;
  	logic sgeu;
        assign diff = SrcA + ~SrcB + 1 ;
        assign udiff = $signed(SrcA) + $signed(~SrcB) +1;
    	assign sub_signed   = diff  & 32'h80000000;
  	assign sub_unsigned = udiff & 32'h10000000;
  	
        always_latch
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0001:        // OR
                    ALUResult = SrcA | SrcB;
            4'b0010:        // ADD
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b0011:        // XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0100:        // Left Shift
                    ALUResult = SrcA << SrcB[4:0];
            4'b0101:        // Right Shift
                    ALUResult = SrcA >> SrcB[4:0];
            4'b0110:        // Subtract
                    ALUResult = diff;
            4'b0111:        // Right Shift Arithm
                    ALUResult = $signed(SrcA) >>> SrcB[4:0];

            4'b1000:        // Equal
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b1001:        // Not Equal
                    ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b1100:        // Less Than
                    if (sub_signed == 32'h80000000)  begin
		  	slt = 1;
			ALUResult = {31'b0,slt};
			end
			else begin
			slt = 0;
			ALUResult = {31'b0,slt};
			end
            4'b1101:        // Greater/Equal Than
                    if (sub_signed == 32'h80000000)  begin
		  	sge = 0;
			ALUResult = {31'b0,sge};
			end
			else begin
			sge = 1;
			ALUResult = {31'b0,sge};
			end
            4'b1110:        // Unsigned Less Than
                    if  ((SrcA[31] ^ SrcB[31] == 0) && (sub_unsigned == 32'h10000000)) 
				begin  
				sltu = 1;
				ALUResult = {31'b0,sltu};
				end
			   else if ((SrcA[31] ^ SrcB[31] == 1) && (sub_unsigned == 32'b0))
				begin
				sltu =1;
				ALUResult = {31'b0,sltu};
				end
				else begin		     
				sltu = 0;
				ALUResult = {31'b0,sltu};
			   end 
            4'b1111:        // Unsigned Greater/Equal Than
                     if  ((SrcA[31] ^ SrcB[31] == 0) && (sub_unsigned == 32'h10000000)) 
				begin  
				sgeu = 0;
				ALUResult = {31'b0,sgeu};
				end
			   else if ((SrcA[31] ^ SrcB[31] == 1) && (sub_unsigned == 32'b0))
				begin
				sgeu =0;
				ALUResult = {31'b0,sgeu};
				end
				else begin		     
				sgeu = 1;
				ALUResult = {31'b0,sgeu};
			   end 
            4'b1010:        // Always True, for jal
                    ALUResult = 1;
            default:
                    ALUResult = 0;
            endcase
        end
endmodule

