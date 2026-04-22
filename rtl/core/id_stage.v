`include "../include/rv32i_defs.vh"

module id_stage (
    input wire                      clk_i               ,
    input wire                      rst_i               ,

    input wire [31:0]               if_id_instr         ,
    input wire [31:0]               if_id_pc            ,
    input wire [31:0]               if_id_pcplus        ,

    output wire [31:0]              id_ex_instr_o       ,
    output wire [`CONTROL_BIT-1:0]  id_ex_ctrl_o        ,
    output wire [31:0]              id_ex_rs1_o         ,
    output wire [31:0]              id_ex_rs2_o         ,
    output wire [31:0]              id_ex_imm_o         ,

    output wire [ 4:0]              id_ex_rd_addr_o     ,
    output wire [31:0]              id_ex_pc_o          ,
    output wire [31:0]              id_ex_pcplus_o      ,

    input wire  [ 4:0]              wb_id_rd_addr_i     ,
    input wire  [31:0]              wb_id_rd_i          ,
    input wire                      wb_id_rd_en_i       
);

wire    [`DECODE_INST_BIT-1:0]  decode_inst_w   ;

reg     [31:0]                  immediate_r     ;
reg     [2:0]                   instr_type_r    ;
reg     [`CONTROL_BIT-1:0]      ctrl_signal_r   ; 

wire    [31:0]                  rs1_w           ;
wire    [31:0]                  rs2_w           ;

base_regfile regfile_id
(
   .clk_i       (clk_i)                     ,
   .rst_i       (rst_i)                     ,
   .rs1_addr_i  (if_id_instr[19:15])        ,
   .rs2_addr_i  (if_id_instr[24:20])        ,
   .rs1_data_o  (rs1_w)                     ,
   .rs2_data_o  (rs2_w)                     ,
   .rd_addr_i   (wb_id_rd_addr_i)           ,
   .rd_i        (wb_id_rd_i)                ,
   .wr_i        (wb_id_rd_en_i)
);

assign decode_inst_w = {
    if_id_instr[`CTRL_SIGN]     ,
    if_id_instr[`CTRL_FUNCT3]   ,
    if_id_instr[`CTRL_OPCODE5]
};

always @(*) begin
    casez(decode_inst_w)
        `DECODE_ADD    : begin ctrl_signal_r = `CONTROL_ADD    ; instr_type_r = `R_TYPE; end 
        `DECODE_SUB    : begin ctrl_signal_r = `CONTROL_SUB    ; instr_type_r = `R_TYPE; end 
        `DECODE_SLL    : begin ctrl_signal_r = `CONTROL_SLL    ; instr_type_r = `R_TYPE; end 
        `DECODE_SLT    : begin ctrl_signal_r = `CONTROL_SLT    ; instr_type_r = `R_TYPE; end 
        `DECODE_SLTU   : begin ctrl_signal_r = `CONTROL_SLTU   ; instr_type_r = `R_TYPE; end 
        `DECODE_XOR    : begin ctrl_signal_r = `CONTROL_XOR    ; instr_type_r = `R_TYPE; end 
        `DECODE_SRL    : begin ctrl_signal_r = `CONTROL_SRL    ; instr_type_r = `R_TYPE; end 
        `DECODE_SRA    : begin ctrl_signal_r = `CONTROL_SRA    ; instr_type_r = `R_TYPE; end 
        `DECODE_OR     : begin ctrl_signal_r = `CONTROL_OR     ; instr_type_r = `R_TYPE; end 
        `DECODE_AND    : begin ctrl_signal_r = `CONTROL_AND    ; instr_type_r = `R_TYPE; end 
        `DECODE_ADDI   : begin ctrl_signal_r = `CONTROL_ADDI   ; instr_type_r = `I_TYPE; end 
        `DECODE_SLTI   : begin ctrl_signal_r = `CONTROL_SLTI   ; instr_type_r = `I_TYPE; end 
        `DECODE_SLTIU  : begin ctrl_signal_r = `CONTROL_SLTIU  ; instr_type_r = `I_TYPE; end 
        `DECODE_XORI   : begin ctrl_signal_r = `CONTROL_XORI   ; instr_type_r = `I_TYPE; end 
        `DECODE_ORI    : begin ctrl_signal_r = `CONTROL_ORI    ; instr_type_r = `I_TYPE; end 
        `DECODE_ANDI   : begin ctrl_signal_r = `CONTROL_ANDI   ; instr_type_r = `I_TYPE; end 
        `DECODE_SLLI   : begin ctrl_signal_r = `CONTROL_SLLI   ; instr_type_r = `I_TYPE; end 
        `DECODE_SRLI   : begin ctrl_signal_r = `CONTROL_SRLI   ; instr_type_r = `I_TYPE; end 
        `DECODE_SRAI   : begin ctrl_signal_r = `CONTROL_SRAI   ; instr_type_r = `I_TYPE; end 
        `DECODE_LB     : begin ctrl_signal_r = `CONTROL_LB     ; instr_type_r = `I_TYPE; end 
        `DECODE_LH     : begin ctrl_signal_r = `CONTROL_LH     ; instr_type_r = `I_TYPE; end 
        `DECODE_LW     : begin ctrl_signal_r = `CONTROL_LW     ; instr_type_r = `I_TYPE; end 
        `DECODE_LBU    : begin ctrl_signal_r = `CONTROL_LBU    ; instr_type_r = `I_TYPE; end 
        `DECODE_LHU    : begin ctrl_signal_r = `CONTROL_LHU    ; instr_type_r = `I_TYPE; end 
        `DECODE_SB     : begin ctrl_signal_r = `CONTROL_SB     ; instr_type_r = `S_TYPE; end 
        `DECODE_SH     : begin ctrl_signal_r = `CONTROL_SH     ; instr_type_r = `S_TYPE; end 
        `DECODE_SW     : begin ctrl_signal_r = `CONTROL_SW     ; instr_type_r = `S_TYPE; end 
        `DECODE_BEQ    : begin ctrl_signal_r = `CONTROL_BEQ    ; instr_type_r = `B_TYPE; end 
        `DECODE_BNE    : begin ctrl_signal_r = `CONTROL_BNE    ; instr_type_r = `B_TYPE; end 
        `DECODE_BLT    : begin ctrl_signal_r = `CONTROL_BLT    ; instr_type_r = `B_TYPE; end 
        `DECODE_BGE    : begin ctrl_signal_r = `CONTROL_BGE    ; instr_type_r = `B_TYPE; end 
        `DECODE_BLTU   : begin ctrl_signal_r = `CONTROL_BLTU   ; instr_type_r = `B_TYPE; end 
        `DECODE_BGEU   : begin ctrl_signal_r = `CONTROL_BGEU   ; instr_type_r = `B_TYPE; end 
        `DECODE_LUI    : begin ctrl_signal_r = `CONTROL_LUI    ; instr_type_r = `U_TYPE; end 
        `DECODE_AUIPC  : begin ctrl_signal_r = `CONTROL_AUIPC  ; instr_type_r = `U_TYPE; end 
        `DECODE_JAL    : begin ctrl_signal_r = `CONTROL_JAL    ; instr_type_r = `J_TYPE; end 
        `DECODE_JALR   : begin ctrl_signal_r = `CONTROL_JALR   ; instr_type_r = `I_TYPE; end 
        default        : begin ctrl_signal_r = `CONTROL_NOP    ; instr_type_r = `R_TYPE; end // Bilinmeyen Instruction - Jump to Exception Handler (Handle)
    endcase
end

// IMMEDIATE GENERATOR

/* Instruciton[6:2]
R Type         = 01100
I Type         = 00100
I (Load) Type  = 00000
S Type         = 01000
B Type         = 11000
U (LUI) Type   = 01101
U (AUIPC) TYPE = 00101
J (JAL) Type   = 11011
J (JALR) Type  = 11001
*/

always @(*) begin
    case (instr_type_r)
        `I_TYPE  : begin immediate_r = { {21{if_id_instr[31]}}, if_id_instr[30:25], if_id_instr[24:21], if_id_instr[20]                                   };    end 
        `S_TYPE  : begin immediate_r = { {21{if_id_instr[31]}}, if_id_instr[30:25], if_id_instr[11:8] , if_id_instr[7]                                    };    end 
        `B_TYPE  : begin immediate_r = { {20{if_id_instr[31]}}, if_id_instr[7]    , if_id_instr[30:25], if_id_instr[11:8], {1{1'b0}}                      };    end 
        `U_TYPE  : begin immediate_r = {     if_id_instr[31]  , if_id_instr[30:20], if_id_instr[19:12], {12{1'b0}}                                        };    end 
        `J_TYPE  : begin immediate_r = { {12{if_id_instr[31]}}, if_id_instr[19:12], if_id_instr[20]   , if_id_instr[30:25], if_id_instr[24:21], {1{1'b0}} };    end 
        default  : begin immediate_r = 32'h0;                                                                                                                   end
    endcase
end

//

assign id_ex_instr_o   = if_id_instr;
assign id_ex_ctrl_o    = ctrl_signal_r;
assign id_ex_rs1_o     = rs1_w;
assign id_ex_rs2_o     = rs2_w;
assign id_ex_imm_o     = immediate_r;
assign id_ex_rd_addr_o = if_id_instr[11:7];
assign id_ex_pc_o      = if_id_pc;
assign id_ex_pcplus_o  = if_id_pcplus;
    
endmodule