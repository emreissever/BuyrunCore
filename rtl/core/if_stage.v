`include "../include/rv32i_defs.vh"

module if_stage #(
   parameter [31:0] BOOT_ADDR = 32'h0000_0000
)(
    input   wire        clk_i               ,
    input   wire        rst_i               ,
    
    // IMEM Interface
    input wire  [31:0]  imem_if_instr_i     ,
    output wire [31:0]  if_imem_pc_o        ,

    // ID Stage Interface
    output reg  [31:0]  if_id_instr_o       ,
    output reg  [31:0]  if_id_pc_o          ,
    output reg  [31:0]  if_id_pcplus_o      ,
    input wire          id_if_ready_i       ,

    // From EX stage 
    input wire          ex_if_br_taken_i    ,
    input wire [31:0]   ex_if_br_addr_i
);

reg  [31:0] pc_r;
wire [31:0] pcplus_w;

always @(posedge clk_i) begin
    if (rst_i) begin
        pc_r <= BOOT_ADDR       ;
    end else if (ex_if_br_taken_i) begin
        pc_r <= ex_if_br_addr_i ; 
    end else if (id_if_ready_i) begin
        pc_r <= pcplus_w        ;
    end 
end

assign pcplus_w = pc_r + 4 ; 


// IF/ID Pipeline Register //
always @(posedge clk_i) begin
    if (rst_i) begin
        if_id_instr_o   <= `I_NOP           ;
        if_id_pc_o      <= BOOT_ADDR        ;
        if_id_pcplus_o  <= pcplus_w         ;
    end else if (ex_if_br_taken_i) begin 
        if_id_instr_o   <= `I_NOP           ;
        if_id_pc_o      <= ex_if_br_addr_i  ;
        if_id_pcplus_o  <= pcplus_w         ;
    end else if (id_if_ready_i) begin
        if_id_instr_o   <= imem_if_instr_i  ;
        if_id_pc_o      <= pc_r             ;
        if_id_pcplus_o  <= pcplus_w         ;
    end 
end

assign if_imem_pc_o = pc_r ; 

endmodule
