`include "../include/rv32i_defs.vh"

module alu (
   input    wire [3 :0] ctrl_i      , 
   input    wire [31:0] operand1_i  ,
   input    wire [31:0] operand2_i  ,
   output   reg  [31:0] result_o    
);

wire [31:0] result_xor_w   ;
wire [31:0] result_or_w    ;
wire [31:0] result_and_w   ;
wire [31:0] result_sll_w   ;
wire [31:0] result_srl_w   ;
wire [31:0] result_sra_w   ;
wire [31:0] result_slt_w   ;
wire [31:0] result_sltu_w  ;
wire [31:0] result_seq_w   ;

assign result_or_w   = operand1_i   |    operand2_i                                     ;
assign result_xor_w  = operand1_i   ^    operand2_i                                     ;
assign result_and_w  = operand1_i   &    operand2_i                                     ;
assign result_sll_w  = operand1_i   <<   operand2_i[4:0]                                ;
assign result_srl_w  = operand1_i   >>   operand2_i[4:0]                                ;
assign result_sra_w  = $signed(operand1_i) >>> operand2_i[4:0]                          ;
assign result_slt_w  = ($signed(operand1_i) < $signed(operand2_i))   ? 32'b1 : 32'b0    ;
assign result_sltu_w = (operand1_i < operand2_i)                     ? 32'b1 : 32'b0    ;

assign result_seq_w  = (operand1_i == operand2_i)                    ? 32'b1 : 32'b0    ; //

// Substraction - 2's Complement Logic
wire [31:0] operand2_mux    =   (ctrl_i == `EXOP_SUB) 
                                ? ~operand2_i : operand2_i ;
wire [31:0] add_result_w    =   operand1_i + operand2_mux
                                + {31'b0, (ctrl_i == `EXOP_SUB)};

// wire firstCarry = (ctrl_i == `EXOP_SUB) ; 
// wire [32:0] addition_operand1_w = (firstCarry) ? { operand1_i,firstCarry} : {operand1_i,firstCarry}  ; 
// wire [32:0] addition_operand2_w = (firstCarry) ? {~operand2_i,firstCarry} : {operand2_i,firstCarry}  ; 
// wire [32:0] add_result_w ; 

// assign add_result_w = addition_operand1_w + addition_operand2_w ;

always @(*) begin
    case (ctrl_i)
        `EXOP_ADD , `EXOP_SUB:   result_o = add_result_w ;
        `EXOP_SLL :              result_o = result_sll_w ;
        `EXOP_SLT :              result_o = result_slt_w ;
        `EXOP_SLTU:              result_o = result_sltu_w;
        `EXOP_XOR :              result_o = result_xor_w ;
        `EXOP_SRL :              result_o = result_srl_w ;
        `EXOP_SRA :              result_o = result_sra_w ;
        `EXOP_OR  :              result_o = result_or_w  ;
        `EXOP_AND :              result_o = result_and_w ;
        `EXOP_SEQ :              result_o = result_seq_w ;
        `EXOP_PASS:              result_o = operand2_i   ;
        default:                 result_o = 32'b0        ;
    endcase
end

endmodule
