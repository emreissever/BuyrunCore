`include "../include/rv32i_defs.vh"

module ex_stage (
    input   wire                    clk_i               ,
    input   wire                    rst_i               ,

    input wire [31:0]               id_ex_instr_i       ,
    input wire [`CONTROL_BIT-1:0]   id_ex_ctrl_i        ,
    input wire [31:0]               id_ex_rs1_i         ,
    input wire [31:0]               id_ex_rs2_i         ,
    input wire [31:0]               id_ex_imm_i         ,

    input wire [ 4:0]               id_ex_rd_addr_i     ,
    input wire [31:0]               id_ex_pc_i          ,
    input wire [31:0]               id_ex_pcplus_i      ,

    output reg [31:0]               ex_mem_instr_o      ,
    output reg [`CONTROL_BIT-1:0]   ex_mem_ctrl_o       ,
    output reg [31:0]               ex_mem_alu_result_o ,
    output reg [31:0]               ex_mem_rs2_o        ,

    output reg [ 4:0]               ex_mem_rd_addr_o    ,
    output reg [31:0]               ex_mem_pc_o         ,
    output reg [31:0]               ex_mem_pcplus_o     ,

    output reg                      ex_if_br_taken_o    ,
    output reg [31:0]               ex_if_br_addr_o     
);

reg  [31:0] operand1_r      ;
reg  [31:0] operand2_r      ;
reg         branch_taken_r  ;

wire [31:0] alu_result_w    ;

alu alu_ex
(
   .ctrl_i     (id_ex_ctrl_i[`EXOP])    ,
   .operand1_i (operand1_r)             ,
   .operand2_i (operand2_r)             ,
   .result_o   (alu_result_w)
);

// Operand Muxing //

always @(*) begin
    case (id_ex_ctrl_i[`OPERAND])
        `OPERAND_REG: begin
            operand1_r = id_ex_rs1_i;
            operand2_r = id_ex_rs2_i;
        end

        `OPERAND_IMM: begin
            operand1_r = id_ex_rs1_i;
            operand2_r = id_ex_imm_i;
        end

        `OPERAND_PC: begin
            operand1_r = id_ex_pc_i;
            operand2_r = 32'b0;
        end

        `OPERAND_PCIMM: begin
            operand1_r = id_ex_pc_i;
            operand2_r = id_ex_imm_i;
        end
        default: begin
            operand1_r = 32'b0;
            operand2_r = 32'b0;
        end
    endcase
end 

// Branch Comparator // 

always @(*) begin
    case(id_ex_ctrl_i[`BRANCH])
        `BRANCH_EQ      : branch_taken_r = (id_ex_rs1_i == id_ex_rs2_i) ;
        `BRANCH_NE      : branch_taken_r = (id_ex_rs1_i != id_ex_rs2_i) ;
        `BRANCH_LT      : branch_taken_r = ($signed(id_ex_rs1_i) <  $signed(id_ex_rs2_i));
        `BRANCH_GE      : branch_taken_r = ($signed(id_ex_rs1_i) >= $signed(id_ex_rs2_i));
        `BRANCH_LTU     : branch_taken_r = (id_ex_rs1_i < id_ex_rs2_i);
        `BRANCH_GEU     : branch_taken_r = (id_ex_rs1_i >= id_ex_rs2_i);
        `BRANCH_NONE    : branch_taken_r = 1'b0 ;
        default: branch_taken_r = 1'b0;
    endcase 
end 

// EX/MEM Pipeline Registers // 

always @(posedge clk_i) begin
    if (rst_i) begin
        ex_mem_instr_o      <= `I_NOP           ;
        ex_mem_ctrl_o       <= `CONTROL_NOP     ;
        ex_mem_alu_result_o <= 32'b0            ;
        ex_mem_rs2_o        <= 32'b0            ;
        ex_mem_rd_addr_o    <= 5'b0             ;
        ex_mem_pc_o         <= 32'b0            ;
        ex_mem_pcplus_o     <= 32'b0            ;

        ex_if_br_addr_o     <= 32'b0            ;
        ex_if_br_taken_o    <= 1'b0             ;
    end else begin
        ex_mem_instr_o      <= id_ex_instr_i    ;
        ex_mem_ctrl_o       <= id_ex_ctrl_i     ;
        ex_mem_alu_result_o <= alu_result_w     ;
        ex_mem_rs2_o        <= alu_result_w     ;
        ex_mem_rd_addr_o    <= id_ex_rd_addr_i  ;
        ex_mem_pc_o         <= id_ex_pc_i       ;
        ex_mem_pcplus_o     <= id_ex_pcplus_i   ;

        ex_if_br_addr_o     <= alu_result_w     ;
        ex_if_br_taken_o    <= branch_taken_r   ;
    end 
end

endmodule
