module wrapper
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data,// The ALU_Result
    
    //Peri
    input logic [7:0] io_sw,
    output logic [6:0] io_hex0, 
    output logic [6:0] io_hex1, 
    output logic [31:0] io_hex2, 
    output logic [31:0] io_hex3, 
    output logic [31:0] io_hex4, 
    output logic [31:0] io_hex5, 
    output logic [31:0] io_hex6, 
    output logic [31:0] io_hex7 
    
    );
	 logic clk_divided;
	 clk_divider clock_slower (.clk_i(clk),
   .clk_o(clk_divided));

logic [6:0] opcode;
logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, JalrSel;
logic [1:0] RWSel;
logic [1:0] ALUop;
logic [1:0] ALUop_Reg;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;

    Controller CU(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, ALUop, Branch, JalrSel, RWSel);
    
    ALUController AC(ALUop_Reg, Funct7, Funct3, Operation);

    Datapath DP(clk, reset, RegWrite , MemtoReg, ALUSrc , MemWrite, MemRead, Branch, JalrSel, ALUop, RWSel, Operation, opcode, Funct7, Funct3, ALUop_Reg, WB_Data, io_sw, io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7);
        
endmodule
