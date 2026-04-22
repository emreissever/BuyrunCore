`include "../include/rv32i_defs.vh"

module wb_stage (
    input wire  [`CONTROL_BIT-1:0]  mem_wb_ctrl_i       ,
    input wire  [31:0]              mem_wb_alu_result_i ,
    input wire  [31:0]              mem_wb_read_data_i  ,
    input wire  [ 4:0]              mem_wb_rd_addr_i    ,
    input wire  [31:0]              mem_wb_pcplus_i     ,

    // To regfile
    output wire [ 4:0]              wb_rd_addr_o        ,
    output wire [31:0]              wb_rd_data_o        ,
    output wire                     wb_rd_en_o          
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

// Outputs
assign wb_rd_data_o = wb_data_r;
assign wb_rd_addr_o = mem_wb_rd_addr_i;
assign wb_rd_en_o   = mem_wb_ctrl_i[`REGEN];

endmodule