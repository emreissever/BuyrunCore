`ifndef RV32I_DEFS_VH
`define RV32I_DEFS_VH

`define I_NOP       32'h00000013   // ADDI x0, x0, 0

// RV32I Instructions = 37 Instructions 
// FENCE and SYSTEM Instructions are not supported now !! 

`define I_ADD        32'b0000000_?????_?????_000_?????_0110011
`define I_SUB        32'b0100000_?????_?????_000_?????_0110011
`define I_SLL        32'b0000000_?????_?????_001_?????_0110011
`define I_SLT        32'b0000000_?????_?????_010_?????_0110011
`define I_SLTU       32'b0000000_?????_?????_011_?????_0110011
`define I_XOR        32'b0000000_?????_?????_100_?????_0110011
`define I_SRL        32'b0000000_?????_?????_101_?????_0110011
`define I_SRA        32'b0100000_?????_?????_101_?????_0110011
`define I_OR         32'b0000000_?????_?????_110_?????_0110011
`define I_AND        32'b0000000_?????_?????_111_?????_0110011

`define I_ADDI       32'b???????_?????_?????_000_?????_0010011
`define I_SLTI       32'b???????_?????_?????_010_?????_0010011
`define I_SLTIU      32'b???????_?????_?????_011_?????_0010011
`define I_XORI       32'b???????_?????_?????_100_?????_0010011
`define I_ORI        32'b???????_?????_?????_110_?????_0010011
`define I_ANDI       32'b???????_?????_?????_111_?????_0010011
`define I_SLLI       32'b0000000_?????_?????_001_?????_0010011
`define I_SRLI       32'b0000000_?????_?????_101_?????_0010011
`define I_SRAI       32'b0100000_?????_?????_101_?????_0010011

`define I_LB         32'b???????_?????_?????_000_?????_0000011
`define I_LH         32'b???????_?????_?????_001_?????_0000011
`define I_LW         32'b???????_?????_?????_010_?????_0000011
`define I_LBU        32'b???????_?????_?????_100_?????_0000011
`define I_LHU        32'b???????_?????_?????_101_?????_0000011

`define I_SB         32'b???????_?????_?????_000_?????_0100011
`define I_SH         32'b???????_?????_?????_001_?????_0100011
`define I_SW         32'b???????_?????_?????_010_?????_0100011

`define I_BEQ        32'b???????_?????_?????_000_?????_1100011
`define I_BNE        32'b???????_?????_?????_001_?????_1100011
`define I_BLT        32'b???????_?????_?????_100_?????_1100011
`define I_BGE        32'b???????_?????_?????_101_?????_1100011
`define I_BLTU       32'b???????_?????_?????_110_?????_1100011
`define I_BGEU       32'b???????_?????_?????_111_?????_1100011
`define I_LUI        32'b???????_?????_?????_???_?????_0110111
`define I_AUIPC      32'b???????_?????_?????_???_?????_0010111
`define I_JAL        32'b???????_?????_?????_???_?????_1101111
`define I_JALR       32'b???????_?????_?????_000_?????_1100111


// Instruction Types
`define R_TYPE 3'b000
`define I_TYPE 3'b001
`define S_TYPE 3'b010
`define B_TYPE 3'b011
`define U_TYPE 3'b100
`define J_TYPE 3'b101

// Decode Instruction Fields //

// Inst[30] Inst[14:12] Inst[6:2] = 9 Bits

`define DECODE_INST_BIT 9

`define CTRL_SIGN       30
`define CTRL_FUNCT3     14:12
`define CTRL_OPCODE5    6:2

`define DECODE_ADD      9'b000001100
`define DECODE_SUB      9'b100001100
`define DECODE_SLL      9'b000101100
`define DECODE_SLT      9'b001001100
`define DECODE_SLTU     9'b001101100
`define DECODE_XOR      9'b010001100
`define DECODE_SRL      9'b010101100
`define DECODE_SRA      9'b110101100
`define DECODE_OR       9'b011001100
`define DECODE_AND      9'b011101100

`define DECODE_ADDI     9'b?00000100
`define DECODE_SLTI     9'b?01000100
`define DECODE_SLTIU    9'b?01100100
`define DECODE_XORI     9'b?10000100
`define DECODE_ORI      9'b?11000100
`define DECODE_ANDI     9'b?11100100
`define DECODE_SLLI     9'b000100100
`define DECODE_SRLI     9'b010100100
`define DECODE_SRAI     9'b110100100

`define DECODE_LB       9'b?00000000
`define DECODE_LH       9'b?00100000
`define DECODE_LW       9'b?01000000
`define DECODE_LBU      9'b?10000000
`define DECODE_LHU      9'b?10100000

`define DECODE_SB       9'b?00001000
`define DECODE_SH       9'b?00101000
`define DECODE_SW       9'b?01001000

`define DECODE_BEQ      9'b?00011000
`define DECODE_BNE      9'b?00111000
`define DECODE_BLT      9'b?10011000
`define DECODE_BGE      9'b?10111000
`define DECODE_BLTU     9'b?11011000
`define DECODE_BGEU     9'b?11111000

`define DECODE_LUI      9'b????01101
`define DECODE_AUIPC    9'b????00101
`define DECODE_JAL      9'b????11011
`define DECODE_JALR     9'b?00011001

// Control Signal Definitions //

`define CONTROL_BIT 17

`define WB        1:0   // 2 Bit
`define REGEN     2:2   // 1 Bit
`define MEMACC    7:3   // 5 Bit
`define EXOP      11:8  // 4 Bit
`define BRANCH    14:12 // 3 Bit
`define OPERAND   16:15 // 2 Bit

// 
`define WB_NONE         2'b00 // may need be fixed
`define WB_READDATA     2'b01
`define WB_ALURESULT    2'b10
`define WB_PCPLUS       2'b11

//
`define REGEN_NOTWRITE  1'b0
`define REGEN_WRITE     1'b1

// 1 Bit Enable _ 1 Bit Write Enable _ 1 Bit Signed _ 2 Bit Size (00=word, 01=half, 10=byte)
`define MEMACC_NONE     5'b0_0_0_00
`define MEMACC_LW       5'b1_0_1_00
`define MEMACC_LH       5'b1_0_1_01
`define MEMACC_LHU      5'b1_0_0_01
`define MEMACC_LB       5'b1_0_1_10
`define MEMACC_LBU      5'b1_0_0_10
`define MEMACC_SW       5'b1_1_0_00
`define MEMACC_SH       5'b1_1_0_01
`define MEMACC_SB       5'b1_1_0_10

//
`define BRANCH_NONE     3'b000
`define BRANCH_EQ       3'b011 
`define BRANCH_NE       3'b001
`define BRANCH_LT       3'b100 
`define BRANCH_GE       3'b010
`define BRANCH_LTU      3'b101
`define BRANCH_GEU      3'b110
`define BRANCH_JAL      3'b111 // Same
`define BRANCH_JALR     3'b111 // Same

//
`define EXOP_PASS     4'h0
`define EXOP_ADD      4'h1
`define EXOP_SUB      4'h2
`define EXOP_SLL      4'h3
`define EXOP_SLT      4'hC 
`define EXOP_SLTU     4'hD 
`define EXOP_XOR      4'h6
`define EXOP_SRL      4'h7
`define EXOP_SRA      4'h8
`define EXOP_OR       4'h9
`define EXOP_AND      4'hA

`define EXOP_SEQ      4'hB

//
`define OPERAND_REG     2'b00
`define OPERAND_IMM     2'b01
`define OPERAND_PC      2'b10
`define OPERAND_PCIMM   2'b11
// LUI has handled by EXOP_PASS in ALU

// Control Signal Concatenation //

`define CONTROL_NOP           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTORL_NOP_EXECUTE   {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTORL_NOP_MEM       {                                              `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_NOP_WB        {                                                             `REGEN_NOTWRITE , `WB_NONE     }

`define CONTROL_ADD           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SUB           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_SUB  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SLL           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_SLL  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SLT           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_SLT  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SLTU          {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_SLTU , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_XOR           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_XOR  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SRL           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_SRL  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SRA           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_SRA  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_OR            {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_OR   , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_AND           {`OPERAND_REG   ,  `BRANCH_NONE , `EXOP_AND  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
// 
`define CONTROL_LUI           {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_PASS , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_AUIPC         {`OPERAND_PCIMM ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}

`define CONTROL_ADDI          {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SLLI          {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_SLL  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SLTI          {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_SLT  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SLTIU         {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_SLTU , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_XORI          {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_XOR  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SRLI          {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_SRL  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_SRAI          {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_SRA  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_ORI           {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_OR   , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
`define CONTROL_ANDI          {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_AND  , `MEMACC_NONE , `REGEN_WRITE    , `WB_ALURESULT}
 
`define CONTROL_LB            {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_LB   , `REGEN_WRITE    , `WB_READDATA }
`define CONTROL_LH            {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_LH   , `REGEN_WRITE    , `WB_READDATA }
`define CONTROL_LW            {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_LW   , `REGEN_WRITE    , `WB_READDATA }
`define CONTROL_LBU           {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_LBU  , `REGEN_WRITE    , `WB_READDATA }
`define CONTROL_LHU           {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_LHU  , `REGEN_WRITE    , `WB_READDATA }
 
`define CONTROL_SB            {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_SB   , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_SH            {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_SH   , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_SW            {`OPERAND_IMM   ,  `BRANCH_NONE , `EXOP_ADD  , `MEMACC_SW   , `REGEN_NOTWRITE , `WB_NONE     }

`define CONTROL_BEQ           {`OPERAND_PCIMM ,  `BRANCH_EQ   , `EXOP_SEQ  , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_BNE           {`OPERAND_PCIMM ,  `BRANCH_NE   , `EXOP_SEQ  , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_BLT           {`OPERAND_PCIMM ,  `BRANCH_LT   , `EXOP_SLT  , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_BGE           {`OPERAND_PCIMM ,  `BRANCH_GE   , `EXOP_SLT  , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_BLTU          {`OPERAND_PCIMM ,  `BRANCH_LTU  , `EXOP_SLTU , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }
`define CONTROL_BGEU          {`OPERAND_PCIMM ,  `BRANCH_GEU  , `EXOP_SLTU , `MEMACC_NONE , `REGEN_NOTWRITE , `WB_NONE     }

`define CONTROL_JAL           {`OPERAND_PCIMM ,  `BRANCH_JAL  , `EXOP_ADD  , `MEMACC_NONE , `REGEN_WRITE    , `WB_PCPLUS   }
`define CONTROL_JALR          {`OPERAND_IMM   ,  `BRANCH_JALR , `EXOP_ADD  , `MEMACC_NONE , `REGEN_WRITE    , `WB_PCPLUS   }

// Opcodes (instr[6:0])

// R-type
`define OPCODE_OP       7'b0110011

// I-type (ALU immediate)
`define OPCODE_OP_IMM   7'b0010011

// I-type (loads)
`define OPCODE_LOAD     7'b0000011

// J-type / I-type (jumps)
`define OPCODE_JAL      7'b1101111
`define OPCODE_JALR     7'b1100111

// U-type
`define OPCODE_LUI      7'b0110111
`define OPCODE_AUIPC    7'b0010111

// B-type
`define OPCODE_BRANCH   7'b1100011

// S-type
`define OPCODE_STORE    7'b0100011




// // funct3 - OP / OP_IMM (instr[14:12])

// `define F3_ADD_SUB      3'b000
// `define F3_SLL          3'b001
// `define F3_SLT          3'b010
// `define F3_SLTU         3'b011
// `define F3_XOR          3'b100
// `define F3_SRL_SRA      3'b101
// `define F3_OR           3'b110
// `define F3_AND          3'b111

// // funct3 - BRANCH (instr[14:12])

// `define F3_BEQ          3'b000
// `define F3_BNE          3'b001
// `define F3_BLT          3'b100
// `define F3_BGE          3'b101
// `define F3_BLTU         3'b110
// `define F3_BGEU         3'b111

// // funct3 - LOAD (instr[14:12])

// `define F3_LB           3'b000
// `define F3_LH           3'b001
// `define F3_LW           3'b010
// `define F3_LBU          3'b100
// `define F3_LHU          3'b101

// // funct3 - STORE (instr[14:12])

// `define F3_SB           3'b000
// `define F3_SH           3'b001
// `define F3_SW           3'b010

// // funct7 (instr[31:25])

// `define F7_BASE         7'b0000000   // ADD, SRL, SLLI, SRLI
// `define F7_ALT          7'b0100000   // SUB, SRA, SRAI

`endif
