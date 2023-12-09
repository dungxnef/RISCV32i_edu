module flopr#
    (parameter WIDTH = 8)
    (input logic clk, rst,
     input logic [WIDTH-1:0] d,
     input logic stall,
     output logic [WIDTH-1:0] q);

    always_ff @(posedge clk, posedge rst)
    begin
        if (rst) q <= 0;
        else if (!stall) q<=d;
    end
        
    
endmodule
