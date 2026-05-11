`include "../include/rv32i_defs.vh"

module rv32i_core (
    input  wire        clk_i,
    input  wire        rst_i,

    // External IMEM interface
    input  wire [31:0] imem_instr_i,
    output wire [31:0] imem_pc_o
);

// IF/ID
wire [31:0] if_id_instr_w;
wire [31:0] if_id_pc_w;
wire [31:0] if_id_pcplus_w;
wire        id_if_ready_w;

// ID/EX
wire [31:0]             id_ex_instr_w;
wire [`CONTROL_BIT-1:0] id_ex_ctrl_w;
wire [31:0]             id_ex_rs1_w;
wire [31:0]             id_ex_rs2_w;
wire [31:0]             id_ex_imm_w;
wire [4:0]              id_ex_rd_addr_w;
wire [31:0]             id_ex_pc_w;
wire [31:0]             id_ex_pcplus_w;

// EX/MEM
wire [31:0]             ex_mem_instr_w;
wire [`CONTROL_BIT-1:0] ex_mem_ctrl_w;
wire [31:0]             ex_mem_alu_result_w;
wire [31:0]             ex_mem_rs2_w;
wire [4:0]              ex_mem_rd_addr_w;
wire [31:0]             ex_mem_pc_w;
wire [31:0]             ex_mem_pcplus_w;

// MEM/WB
wire [31:0]             mem_wb_instr_w;
wire [`CONTROL_BIT-1:0] mem_wb_ctrl_w;
wire [31:0]             mem_wb_alu_result_w;
wire [31:0]             mem_wb_read_data_w;
wire [4:0]              mem_wb_rd_addr_w;
wire [31:0]             mem_wb_pc_w;
wire [31:0]             mem_wb_pcplus_w;

// WB -> regfile feedback
wire [4:0]              wb_id_rd_addr_w;
wire [31:0]             wb_id_rd_w;
wire                    wb_id_rd_en_w;

// Branch feedback EX -> IF
wire                    ex_if_br_taken_w;
wire [31:0]             ex_if_br_addr_w;

// Hazard Unit 
wire [ 4:0]             id_hzd_rs1_addr_w;
wire [ 4:0]             id_hzd_rs2_addr_w;
wire                    id_hzd_rs1_used_w;
wire                    id_hzd_rs2_used_w;
wire                    hzd_id_stall_w   ;

// IF Stage
if_stage u_if_stage (
    .clk_i              (clk_i),
    .rst_i              (rst_i),
    .imem_if_instr_i    (imem_instr_i),
    .if_imem_pc_o       (imem_pc_o),

    .if_id_instr_o      (if_id_instr_w),
    .if_id_pc_o         (if_id_pc_w),
    .if_id_pcplus_o     (if_id_pcplus_w),
    .id_if_ready_i      (id_if_ready_w),

    .ex_if_br_taken_i   (ex_if_br_taken_w),
    .ex_if_br_addr_i    (ex_if_br_addr_w)
);

// ID Stage
id_stage u_id_stage (
    .clk_i              (clk_i),
    .rst_i              (rst_i),

    .if_id_instr_i      (if_id_instr_w),
    .if_id_pc_i         (if_id_pc_w),
    .if_id_pcplus_i     (if_id_pcplus_w),
    .id_if_ready_o      (id_if_ready_w), 

    .id_ex_instr_o      (id_ex_instr_w),
    .id_ex_ctrl_o       (id_ex_ctrl_w),
    .id_ex_rs1_o        (id_ex_rs1_w),
    .id_ex_rs2_o        (id_ex_rs2_w),
    .id_ex_imm_o        (id_ex_imm_w),

    .id_ex_rd_addr_o    (id_ex_rd_addr_w),
    .id_ex_pc_o         (id_ex_pc_w),
    .id_ex_pcplus_o     (id_ex_pcplus_w),

    .wb_id_rd_addr_i    (wb_id_rd_addr_w),
    .wb_id_rd_i         (wb_id_rd_w),
    .wb_id_rd_en_i      (wb_id_rd_en_w),
    .id_hzd_rs1_addr_o  (id_hzd_rs1_addr_w),
    .id_hzd_rs2_addr_o  (id_hzd_rs2_addr_w),
    .id_hzd_rs1_used_o  (id_hzd_rs1_used_w),
    .id_hzd_rs2_used_o  (id_hzd_rs2_used_w),
    .hzd_id_stall_i     (hzd_id_stall_w)
);

// EX Stage
ex_stage u_ex_stage (
    .clk_i            (clk_i),
    .rst_i            (rst_i),

    .id_ex_instr_i    (id_ex_instr_w),
    .id_ex_ctrl_i     (id_ex_ctrl_w),
    .id_ex_rs1_i      (id_ex_rs1_w),
    .id_ex_rs2_i      (id_ex_rs2_w),
    .id_ex_imm_i      (id_ex_imm_w),
    .id_ex_rd_addr_i  (id_ex_rd_addr_w),
    .id_ex_pc_i       (id_ex_pc_w),
    .id_ex_pcplus_i   (id_ex_pcplus_w),

    .ex_mem_instr_o      (ex_mem_instr_w),
    .ex_mem_ctrl_o       (ex_mem_ctrl_w),
    .ex_mem_alu_result_o (ex_mem_alu_result_w),
    .ex_mem_rs2_o        (ex_mem_rs2_w),
    .ex_mem_rd_addr_o    (ex_mem_rd_addr_w),
    .ex_mem_pc_o         (ex_mem_pc_w),
    .ex_mem_pcplus_o     (ex_mem_pcplus_w),

    .ex_if_br_taken_o(ex_if_br_taken_w),
    .ex_if_br_addr_o (ex_if_br_addr_w)
);

// MEM Stage
mem_stage u_mem_stage (
    .clk_i              (clk_i),
    .rst_i              (rst_i),

    .ex_mem_instr_i      (ex_mem_instr_w),
    .ex_mem_ctrl_i       (ex_mem_ctrl_w),
    .ex_mem_alu_result_i (ex_mem_alu_result_w),
    .ex_mem_rs2_i        (ex_mem_rs2_w),
    .ex_mem_rd_addr_i    (ex_mem_rd_addr_w),
    .ex_mem_pc_i         (ex_mem_pc_w),
    .ex_mem_pcplus_i     (ex_mem_pcplus_w),

    .mem_wb_instr_o      (mem_wb_instr_w),
    .mem_wb_ctrl_o       (mem_wb_ctrl_w),
    .mem_wb_alu_result_o (mem_wb_alu_result_w),
    .mem_wb_read_data_o  (mem_wb_read_data_w),
    .mem_wb_rd_addr_o    (mem_wb_rd_addr_w),
    .mem_wb_pc_o         (mem_wb_pc_w),
    .mem_wb_pcplus_o     (mem_wb_pcplus_w)
);

// WB Stage
wb_stage u_wb_stage (
    .clk_i                  (clk_i)                 ,
    .rst_i                  (rst_i)                 ,

    .mem_wb_instr_i         (mem_wb_instr_w)        ,
    .mem_wb_ctrl_i          (mem_wb_ctrl_w)         ,
    .mem_wb_alu_result_i    (mem_wb_alu_result_w)   ,
    .mem_wb_read_data_i     (mem_wb_read_data_w)    ,
    .mem_wb_rd_addr_i       (mem_wb_rd_addr_w)      ,
    .mem_wb_pc_i            (mem_wb_pc_w)           ,
    .mem_wb_pcplus_i        (mem_wb_pcplus_w)       ,

    .wb_id_rd_addr_o        (wb_id_rd_addr_w)       ,
    .wb_id_rd_o             (wb_id_rd_w)       ,
    .wb_id_rd_en_o          (wb_id_rd_en_w)
);

hazard_unit u_hazard_unit (
    .id_hzd_rs1_addr_i       (id_hzd_rs1_addr_w),
    .id_hzd_rs2_addr_i       (id_hzd_rs2_addr_w),
    .id_hzd_rs1_used_i       (id_hzd_rs1_used_w),
    .id_hzd_rs2_used_i       (id_hzd_rs2_used_w),
    .ex_hzd_rd_addr_i        (id_ex_rd_addr_w),
    .ex_hzd_reg_wr_en_i      (id_ex_ctrl_w[`REGEN]),
    .mem_hzd_rd_addr_i       (ex_mem_rd_addr_w),
    .mem_hzd_reg_wr_en_i     (ex_mem_ctrl_w[`REGEN]),
    .stall_o                 (hzd_id_stall_w)
);

endmodule
