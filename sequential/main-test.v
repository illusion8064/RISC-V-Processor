`include "main.v"
module main_wrap_tb;
    reg clk;
    main_wrap uut(
        .clk(clk)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    initial begin
        $dumpfile("output.vcd");
        $dumpvars(0, main_wrap_tb);
        $monitor("Time = %0t | PC = %h | Instruction = %h | ALU Result = %h | Read Data = %h | Write Data = %h | RegWrite = %b | Branch = %b",
        $time, uut.pc_add, uut.instruct, uut.alu_result, uut.Readdata, uut.write_data, uut.RegWrite, uut.Branch);
        #100; 
        $finish;
    end
endmodule
