/* verilator lint_off UNUSED */
module instructionmemory#(
    parameter INS_ADDRESS = 9,
    parameter INS_W = 32
     )(
    input logic [ INS_ADDRESS -1:0] ra , // Read address of the instruction memory , comes from PC
    output logic [ INS_W -1:0] rd // Read Data
    );
    

logic [INS_W-1 :0] Inst_mem [(2**(INS_ADDRESS-2))-1:0];

 initial begin
	 	$readmemh("mem/imem1_ini.mem",Inst_mem);
	 end
assign rd =  Inst_mem [ra[INS_ADDRESS-1:2]];  

endmodule

