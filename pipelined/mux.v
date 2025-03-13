module mux_2x1(
    input wire sel,              // 1-bit selection signal
    input wire [63:0] in0,       // 64-bit input 0
    input wire [63:0] in1,       // 64-bit input 1
    output wire [63:0] out       // 64-bit output
);
    assign out = sel ? in1 : in0;  // select in1 if sel is 1, else select in0
endmodule

module mux_3x1(
    input wire [1:0] sel,        // 2-bit selection signal
    input wire [63:0] in0,       // 64-bit input 0
    input wire [63:0] in1,       // 64-bit input 1
    input wire [63:0] in2,       // 64-bit input 2
    output wire [63:0] out       // 64-bit output
);
    assign out = (sel == 2'b00) ? in0 : 
                 (sel == 2'b01) ? in1 : 
                 (sel == 2'b10) ? in2 : 
                 64'b0;  // default case
endmodule