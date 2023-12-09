module BranchUnit
    #(parameter PC_W = 9)
    (input logic clk,reset,
     input logic [PC_W-1:0] Cur_PC,
     input logic [31:0] Imm,
     input logic JalrSel,
     input logic Branch,
     input logic [31:0] AluResult,
     output logic [31:0] PC_Imm,
     output logic [31:0] PC_Four,
     output logic [31:0] BrPC,
     output logic PcSel);

    logic Branch_Sel;
    logic [31:0] PC_Full;
    logic [1:0] Branch_Counter [0:2**PC_W-1];

    assign PC_Full = {23'b0, Cur_PC};
    assign PC_Imm = PC_Full + Imm;
    assign PC_Four = PC_Full + 32'b100;
    
    always_ff @(posedge clk) begin
        if (reset) begin
            Branch_Counter[Cur_PC] <= 2'b00; // Reset counter
        end else if (Branch) begin
            if (AluResult[0]) begin
                if (Branch_Counter[Cur_PC] < 2'b11) begin
                    Branch_Counter[Cur_PC] <= Branch_Counter[Cur_PC] + 1; // Increment counter if branch is not taken
                end
            end else begin
                if (Branch_Counter[Cur_PC] > 2'b00) begin
                    Branch_Counter[Cur_PC] <= Branch_Counter[Cur_PC] - 1; // Decrement counter if branch is taken
                end
            end
        end
    end

    assign Branch_Sel = Branch && (Branch_Counter[Cur_PC] < 2'b10); // Predict branch taken if counter is 2'b00 or 2'b01
    
    assign BrPC = (JalrSel) ? AluResult :     // Jalr -> AluResult
                  (Branch_Sel) ? PC_Imm : 32'b0;  // Branch/Jal -> PC+Imm   // Otherwise, BrPC value is not important
    assign PcSel = JalrSel || Branch_Sel;  // 1:branch (b/jal/jalr) is taken; 0:branch is not taken(choose pc+4)

endmodule
