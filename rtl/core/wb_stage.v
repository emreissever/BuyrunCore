`include "../include/rv32i_defs.vh"

module wb_stage (
    input   wire                    clk_i               ,
    input   wire                    rst_i               ,
    
    input wire  [31:0]              mem_wb_instr_i      ,
    input wire  [`CONTROL_BIT-1:0]  mem_wb_ctrl_i       ,
    input wire  [31:0]              mem_wb_alu_result_i ,
    input wire  [31:0]              mem_wb_read_data_i  ,
    input wire  [ 4:0]              mem_wb_rd_addr_i    ,
    input wire  [31:0]              mem_wb_pc_i         ,
    input wire  [31:0]              mem_wb_pcplus_i     ,

    // To regfile
    output reg  [ 4:0]              wb_id_rd_addr_o     ,
    output reg  [31:0]              wb_id_rd_o          ,
    output reg                      wb_id_rd_en_o          
);

// Writeback mux
reg [31:0] wb_data_r;

always @(*) begin
    case (mem_wb_ctrl_i[`WB])
        `WB_ALURESULT : wb_data_r = mem_wb_alu_result_i;
        `WB_READDATA  : wb_data_r = mem_wb_read_data_i;
        `WB_PCPLUS    : wb_data_r = mem_wb_pcplus_i;
        default       : wb_data_r = 32'b0;
    endcase
end

always @(posedge clk_i) begin
    if (rst_i) begin
        wb_id_rd_o      <= 32'b0;
        wb_id_rd_addr_o <= 5'b0;
        wb_id_rd_en_o   <= 1'b0;
    end else begin
        wb_id_rd_o      <= wb_data_r;
        wb_id_rd_addr_o <= mem_wb_rd_addr_i;
        wb_id_rd_en_o   <= mem_wb_ctrl_i[`REGEN];
    end
end

endmodule
