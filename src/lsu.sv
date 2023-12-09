module lsu#(
    parameter DM_ADDRESS = 10 ,
    parameter DATA_W = 32
    )(
    input logic clk_i,rst_ni,
    input logic MemRead , // comes from control unit
    input logic MemWrite , // Comes from control unit
    input logic [ DM_ADDRESS -1:0] a , // Read / Write address 
    input logic [ DATA_W -1:0] wd , // Write Data
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    output logic [ DATA_W -1:0] rd, // Read Data
    // Peri
    input logic [7:0] io_sw,
    output logic [31:0] io_hex0, 
    output logic [31:0] io_hex1, 
    output logic [31:0] io_hex2, 
    output logic [31:0] io_hex3, 
    output logic [31:0] io_hex4, 
    output logic [31:0] io_hex5, 
    output logic [31:0] io_hex6, 
    output logic [31:0] io_hex7 
    );
   
   logic [31:0] ip_ld_data;
   logic [31:0] op_ld_data;
   logic [31:0] dm_ld_data;
   
   logic data_we,data_re,out_we,sw_we;
   assign data_we = (a < 512 && MemWrite) ? 1 : 0;
   assign data_re = (a < 512 && MemRead) ? 1 : 0;
   assign out_we = (a > 511 && a < 576 && MemWrite) ? 1 : 0;
   assign sw_we = (a > 575 && a < 640) ? 1 : 0;
    
    datamemory dm (
        .clk(clk_i),
        .MemRead(data_re),
        .MemWrite(data_we),
        .a(a[8:0]),
        .wd(wd),
        .Funct3(Funct3),
        .rd(dm_ld_data)
    );
    
    input_module ip (
        .clk_sw(clk_i),
 	.sw_addr(a[5:0]),
 	.sw_wren(sw_we),
 	.sw_data(sw_data),
 	.sw_out(ip_ld_data)
    );
    
    output_module op(
    	.clk_o(clk_i),
 	.o_addr(a[5:0]),
 	.io_data_in(wd),
 	.o_wren(out_we),
 	.io_data_out(op_ld_data)
    );
    
   reg32 hex0 (
 	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h200),
 	.reg_in(wd),
 	.reg_out(io_hex0)
 );
 
 reg32 hex1 (
 	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h208),
 	.reg_in(wd),
 	.reg_out(io_hex1)
 );
 
 reg32 hex2 (
 	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h210),
 	.reg_in(wd),
 	.reg_out(io_hex2)
  );
 
  reg32 hex3 (
  	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h218),
 	.reg_in(wd),
 	.reg_out(io_hex3)
  );
 
  reg32 hex4 (
 	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h220),
 	.reg_in(wd),
 	.reg_out(io_hex4)
   );
 
   reg32 hex5 (
  	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h228),
 	.reg_in(wd),
 	.reg_out(io_hex5)
   );
 
   reg32 hex6 (
 	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h230),
 	.reg_in(wd),
 	.reg_out(io_hex6)
    );
 
    reg32 hex7 (
 	.clk_reg(clk_i),
 	.reg_we(MemWrite),
 	.rstn_reg(rst_ni),
 	.operand_a(a),
 	.operand_b(10'h238),
 	.reg_in(wd),
 	.reg_out(io_hex7)
    );
 
    
    final_mux output_select (
        .main_addr(a),
        .a(dm_ld_data),
        .b(op_ld_data),
        .c(ip_ld_data),
        .mux_out(rd)
    );
    logic [31:0] sw_data;
    latch32 hex_sw (.address(a), 
    .hex0_sw(io_sw[3:0]),
    .hex1_sw(io_sw[7:4]),
    .outs(sw_data) 
);    

endmodule
