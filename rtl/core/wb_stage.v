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
    output wire  [ 4:0]              wb_id_rd_addr_o     ,
    output wire  [31:0]              wb_id_rd_o          ,
    output wire                      wb_id_rd_en_o          
);

// Writeback mux
assign wb_id_rd_o =
    (mem_wb_ctrl_i[`WB] == `WB_ALURESULT) ? mem_wb_alu_result_i :
    (mem_wb_ctrl_i[`WB] == `WB_READDATA ) ? mem_wb_read_data_i  :
    (mem_wb_ctrl_i[`WB] == `WB_PCPLUS   ) ? mem_wb_pcplus_i     :
                                            32'b0;

assign wb_id_rd_addr_o = mem_wb_rd_addr_i;
assign wb_id_rd_en_o   = mem_wb_ctrl_i[`REGEN];

endmodule
