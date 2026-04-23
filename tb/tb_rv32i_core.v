`timescale 1ns/1ps
`include "../rtl/include/rv32i_defs.vh"

module tb_rv32i_core;

reg         clk_i;
reg         rst_i;

reg  [31:0] imem_instr_i;
wire [31:0] imem_pc_o;

integer cycle_count;

// IMEM PLACEHOLDER
always @(*) begin
    case (imem_pc_o)
        32'h0000_0000: imem_instr_i = 32'h00500093; // addi x1, x0, 5
        32'h0000_0004: imem_instr_i = 32'h00102023; // sw x1, 0(x0)
        32'h0000_0008: imem_instr_i = 32'h00002103; // lw x2, 0(x0)
        32'h0000_000C: imem_instr_i = 32'h00000013; // nop
        default:       imem_instr_i = `I_NOP;
    endcase
end

// DUT
rv32i_core dut (
    .clk_i(clk_i),
    .rst_i(rst_i),
    .imem_instr_i(imem_instr_i),
    .imem_pc_o(imem_pc_o)
);

// clock
initial clk_i = 1'b0;
always #5 clk_i = ~clk_i;

initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_rv32i_core);
end

// DEBUG FUNCTIONS AND TASKS // 

function [8*12-1:0] instr_name;
    input [31:0] instr;
    begin
        casez (instr)
            `I_NOP : instr_name = "NOP         ";

            `I_ADD     : instr_name = "ADD         ";
            `I_SUB     : instr_name = "SUB         ";
            `I_SLL     : instr_name = "SLL         ";
            `I_SLT     : instr_name = "SLT         ";
            `I_SLTU    : instr_name = "SLTU        ";
            `I_XOR     : instr_name = "XOR         ";
            `I_SRL     : instr_name = "SRL         ";
            `I_SRA     : instr_name = "SRA         ";
            `I_OR      : instr_name = "OR          ";
            `I_AND     : instr_name = "AND         ";

            `I_ADDI    : instr_name = "ADDI        ";
            `I_SLTI    : instr_name = "SLTI        ";
            `I_SLTIU   : instr_name = "SLTIU       ";
            `I_XORI    : instr_name = "XORI        ";
            `I_ORI     : instr_name = "ORI         ";
            `I_ANDI    : instr_name = "ANDI        ";
            `I_SLLI    : instr_name = "SLLI        ";
            `I_SRLI    : instr_name = "SRLI        ";
            `I_SRAI    : instr_name = "SRAI        ";

            `I_LB      : instr_name = "LB          ";
            `I_LH      : instr_name = "LH          ";
            `I_LW      : instr_name = "LW          ";
            `I_LBU     : instr_name = "LBU         ";
            `I_LHU     : instr_name = "LHU         ";

            `I_SB      : instr_name = "SB          ";
            `I_SH      : instr_name = "SH          ";
            `I_SW      : instr_name = "SW          ";

            `I_BEQ     : instr_name = "BEQ         ";
            `I_BNE     : instr_name = "BNE         ";
            `I_BLT     : instr_name = "BLT         ";
            `I_BGE     : instr_name = "BGE         ";
            `I_BLTU    : instr_name = "BLTU        ";
            `I_BGEU    : instr_name = "BGEU        ";

            `I_LUI     : instr_name = "LUI         ";
            `I_AUIPC   : instr_name = "AUIPC       ";
            `I_JAL     : instr_name = "JAL         ";
            `I_JALR    : instr_name = "JALR        ";

            32'h00000000: instr_name = "-           ";
            default     : instr_name = "UNKNOWN     ";
        endcase
    end
endfunction

task print_pipeline;
    begin
        $display("%4d | %-12s | %-12s | %-12s | %-12s | %-12s",
            cycle_count,
            instr_name(imem_instr_i),
            instr_name(dut.if_id_instr_w),
            instr_name(dut.id_ex_instr_w),
            instr_name(dut.ex_mem_instr_w),
            instr_name(dut.mem_wb_instr_w)
        );

        $display("");
    end
endtask

task print_stage_activity;
    begin
        $display("      EX  : %-12s op1=%08h op2=%08h alu=%08h",
            instr_name(dut.id_ex_instr_w),
            dut.u_ex_stage.operand1_r,
            dut.u_ex_stage.operand2_r,
            dut.u_ex_stage.alu_result_w
        );

        $display("      MEM : %-12s en=%0b we=%0b addr=%08h wdata=%08h rdata=%08h",
            instr_name(dut.ex_mem_instr_w),
            dut.u_mem_stage.mem_enable,
            dut.u_mem_stage.mem_write,
            {26'b0, dut.u_mem_stage.mem_addr, 2'b00},
            dut.ex_mem_rs2_w,
            dut.u_mem_stage.read_data_r
        );

        $display("      WB  : %-12s we=%0b rd=x%0d data=%08h",
            instr_name(dut.mem_wb_instr_w),
            dut.wb_id_rd_en_w,
            dut.wb_id_rd_addr_w,
            dut.wb_id_rd_w
        );

        $display("");
    end
endtask

task show_regfile;
    integer i;
    begin
        $display("");
        $display("========== REGFILE ==========");
        for (i = 0; i < 32; i = i + 1) begin
            $display("x%0d = 0x%08h", i, dut.u_id_stage.u_regfile.regFile[i]);
        end
        $display("");
    end
endtask

task show_dmem;
    integer i;
    begin
        $display("========== DMEM [0:7] ==========");
        for (i = 0; i < 8; i = i + 1) begin
            $display("dmem[%0d] = 0x%08h", i, dut.u_mem_stage.dmem[i]);
        end
        $display("");
    end
endtask

initial begin
    cycle_count = 0;
    $display("");
    $display(" Cyc | %-12s | %-12s | %-12s | %-12s | %-12s",
            "IF", "ID", "EX", "MEM", "WB");
    $display("--------------------------------------------------------------------------");

    rst_i = 1'b1;

    repeat (2) @(posedge clk_i);
    rst_i = 1'b0;

    repeat (10) @(posedge clk_i);

    show_regfile();
    show_dmem();

    $finish;
end

always @(posedge clk_i) begin
    #1;
    print_pipeline();
    print_stage_activity();
    cycle_count = cycle_count + 1;
end

endmodule
