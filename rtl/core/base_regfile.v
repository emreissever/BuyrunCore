module base_regfile 
(
   input   wire           clk_i         ,
   input   wire           rst_i         ,
   input   wire  [ 4:0]   rs1_addr_i    ,
   input   wire  [ 4:0]   rs2_addr_i    ,
   output  wire  [31:0]   rs1_data_o    ,
   output  wire  [31:0]   rs2_data_o    ,
   input   wire  [ 4:0]   rd_addr_i     ,
   input   wire  [31:0]   rd_i          ,
   input   wire           wr_i        
);

reg [31:0] regFile [0:31] ;

assign rs1_data_o = (rs1_addr_i == 5'b0) ? 32'b0 : regFile[rs1_addr_i];
assign rs2_data_o = (rs2_addr_i == 5'b0) ? 32'b0 : regFile[rs2_addr_i];

// NOTE: Resetting general-purpose registers is not architecturally required.
// Kept for early debug convenience.
// Source : RISC-V ISA ABI
integer i ; 
always @(negedge clk_i) begin
   if (rst_i) begin
      for (i = 0; i<32 ; i=i+1) begin
         regFile[i] <= 0 ;
      end
   end
   else if (wr_i && (rd_addr_i != 0)) begin
      regFile[rd_addr_i] <= rd_i ; 
   end
end

endmodule
