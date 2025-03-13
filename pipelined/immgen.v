module immGenerator (
    input  wire [31:0] instr, // 32-bit instruction
    output reg  [63:0] immOut     // 64-bit immediate data
);

  always @(*) begin
    case (instr[6:0]) 
      // I-type instructions (load, immediate ALU)
      7'b0000011, 7'b0010011, 7'b1100111: begin
        immOut = {{52{instr[31]}}, instr[31:20]}; // sign-extended
      end

      // S-type instructions (store)
      7'b0100011: begin
        immOut = {{52{instr[31]}}, instr[31:25], instr[11:7]}; // sign-extended
      end

      // B-type instructions (branch)
      7'b1100011: begin
        immOut = {{52{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; // sign-extended
      end

      // default case
      default: begin
        immOut = 64'b0;
      end
    endcase
  end

endmodule