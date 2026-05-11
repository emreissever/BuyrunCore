/* Hazard Unit
 * Stall-only RAW hazard detection
 * Detects ID-stage source dependencies against EX/MEM pending writes.
 * 
 * Covered RAW cases:
 * [x] ALU-to-ALU hazard
 * [x] Load-use hazard
 * [x] Store-data hazard
 * [x] Branch operand hazard
 * [x] JALR operand hazard
 *
 * Not covered:
 * [ ] Control hazard handling
 * [ ] Forwarding / bypass
*/ 

module hazard_unit (
    input wire [ 4:0]   id_hzd_rs1_addr_i       ,
    input wire [ 4:0]   id_hzd_rs2_addr_i       ,
    input wire          id_hzd_rs1_used_i       ,
    input wire          id_hzd_rs2_used_i       ,

    input wire [ 4:0]   ex_hzd_rd_addr_i        ,
    input wire          ex_hzd_reg_wr_en_i      ,

    input wire [ 4:0]   mem_hzd_rd_addr_i       ,
    input wire          mem_hzd_reg_wr_en_i     ,

    output wire         stall_o                 
);

wire match_ex_rs1   ;
wire match_ex_rs2   ; 

wire match_mem_rs1  ;
wire match_mem_rs2  ;

// RAW Hazard Detect

assign match_ex_rs1   = id_hzd_rs1_used_i                       &&
                        (id_hzd_rs1_addr_i != 5'd0)             &&
                        ex_hzd_reg_wr_en_i                      &&
                        (id_hzd_rs1_addr_i == ex_hzd_rd_addr_i) ;

assign match_ex_rs2   = id_hzd_rs2_used_i                       &&
                        (id_hzd_rs2_addr_i != 5'd0)             &&
                        ex_hzd_reg_wr_en_i                      &&
                        (id_hzd_rs2_addr_i == ex_hzd_rd_addr_i) ;

assign match_mem_rs1  = id_hzd_rs1_used_i                       &&
                        (id_hzd_rs1_addr_i != 5'd0)             &&
                        mem_hzd_reg_wr_en_i                     &&
                        (id_hzd_rs1_addr_i == mem_hzd_rd_addr_i);

assign match_mem_rs2  = id_hzd_rs2_used_i                       &&
                        (id_hzd_rs2_addr_i != 5'd0)             &&
                        mem_hzd_reg_wr_en_i                     &&
                        (id_hzd_rs2_addr_i == mem_hzd_rd_addr_i);

assign stall_o  =   match_ex_rs1  || match_ex_rs2  ||
                    match_mem_rs1 || match_mem_rs2 ;

endmodule
