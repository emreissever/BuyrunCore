module imem_model (
    input wire [31:0]   addr_i   ,
    output reg [31:0]   instr_o     
);

reg [31:0] mem [0:255];

integer i ;

initial begin
    for (i = 0; i < 256; i = i + 1) begin
        mem[i] = 32'h00000013; // nop
    end

    // Makefile cd sim && $(VSIM) 
    $readmemh("../tb/prog.mem", mem);
end

always @(*) begin
    if (addr_i[1:0] != 2'b00)
        instr_o = 32'h00000013; // nop
    else
        instr_o = mem[addr_i[31:2]];
end

endmodule
