`include "../include/rv32i_defs.vh"

module mem_stage (

    input wire                      clk_i               ,
    input wire                      rst_i               ,

    input wire [31:0]               ex_mem_instr_i      ,
    input wire [`CONTROL_BIT-1:0]   ex_mem_ctrl_i       ,
    input wire [31:0]               ex_mem_alu_result_i ,
    input wire [31:0]               ex_mem_rs2_i        ,

    input wire [ 4:0]               ex_mem_rd_addr_i    ,
    input wire [31:0]               ex_mem_pc_i         ,
    input wire [31:0]               ex_mem_pcplus_i     ,

    output reg [31:0]               mem_wb_instr_o      ,
    output reg [`CONTROL_BIT-1:0]   mem_wb_ctrl_o       ,
    output reg [31:0]               mem_wb_alu_result_o ,
    output reg [31:0]               mem_wb_read_data_o  ,
    output reg [ 4:0]               mem_wb_rd_addr_o    ,
    output reg [31:0]               mem_wb_pc_o         ,
    output reg [31:0]               mem_wb_pcplus_o     
);

wire mem_enable = ex_mem_ctrl_i[7];   // MEMACC bit[4]
wire mem_write  = ex_mem_ctrl_i[6]; 

// Data memory — 64 words (256 bytes)
reg [31:0] dmem [0:63];

// Word-aligned address: ignore byte offset (bits [1:0])
// Use bits [7:2] to index 64 entries
wire [5:0] mem_addr = ex_mem_alu_result_i[7:2];

// Memory write (SW) — synchronous
always @(posedge clk_i) begin
    if (mem_enable && mem_write) begin
        dmem[mem_addr] <= ex_mem_rs2_i;
    end
end

// Memory read (LW) — combinational
reg [31:0] read_data_r;

always @(*) begin
    if (mem_enable && !mem_write)
        read_data_r = dmem[mem_addr];
    else
        read_data_r = 32'b0;
end

always @(posedge clk_i) begin
    if (rst_i) begin
        mem_wb_instr_o      <= `I_NOP                ;
        mem_wb_ctrl_o       <= `CONTROL_NOP          ;
        mem_wb_alu_result_o <= 32'b0                 ;
        mem_wb_read_data_o  <= 32'b0                 ;
        mem_wb_rd_addr_o    <= 5'b0                  ;
        mem_wb_pc_o         <= 32'b0                 ;
        mem_wb_pcplus_o     <= 32'b0                 ; 
    end else begin
        mem_wb_instr_o      <= ex_mem_instr_i        ;
        mem_wb_ctrl_o       <= ex_mem_ctrl_i         ;
        mem_wb_alu_result_o <= ex_mem_alu_result_i   ;
        mem_wb_read_data_o  <= read_data_r           ;
        mem_wb_rd_addr_o    <= ex_mem_rd_addr_i      ;
        mem_wb_pc_o         <= ex_mem_pc_i           ;
        mem_wb_pcplus_o     <= ex_mem_pcplus_i       ;
    end 
end
    
endmodule
