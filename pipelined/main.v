`include "alu.v"
`include "control_unit.v"
`include "alu_control.v"
`include "data.v"
`include "instruction.v"
`include "register.v"
`include "immgen.v"
`include "ifid_reg.v"
`include "idex_reg.v"
`include "exmem_reg.v"
`include "memwb_reg.v"
`include "hazard_detection_unit.v"
`include "fwding_unit.v"
`include "mux.v"

module main_wrap(input clk);

    //  PC UPDATION  /././././././././././././././././././././././././././././././././././././././././././
    reg [63:0] pc_add;     // current pc value
    wire [63:0] pc_mux_out;
    wire PCWrite;
    wire [63:0] pcplus4;
    assign pcplus4 = pc_add + 64'd4;  
    initial begin
        pc_add <= 64'b0;
    end
    always @(posedge clk) begin
        if(PCWrite == 1'b1) begin
            pc_add <= pc_mux_out;  
        end
    end
    mux_2x1 pc_mux(.sel(PCsrc), .in0(pcplus4), .in1(MEM_PC), .out(pc_mux_out));
    ///////////////////////////////////////////////////////////////////////////////////////////////////////


    //  INSTRUCTION MEMORY  /./././././././././././././././././././././././././././././././././././././././
    wire [31:0] instruct;       // instruction fetched from memory
    wire IF_ID_Write;
    wire [63:0] ID_PC;
    wire [31:0] ID_Instruction;
    wire PCsrc;    
    instruction_module instruction_module_uut(   // fetches instruction from memory based on curr pc value
        .address(pc_add),
        .instruction(instruct)
    );
    IF_ID_Reg IF_ID_Reg_uut(    // IF_ID REGISTER
        .clk(clk),
        .IF_PC(pc_add),
        .IF_Instruction(instruct),
        .IF_ID_Write(IF_ID_Write),
        .ID_PC(ID_PC),
        .ID_Instruction(ID_Instruction),
        .flush(PCsrc)
    );
    ///////////////////////////////////////////////////////////////////////////////////////////////////////



    //  CONTROL UNIT  /././././././././././././././././././././././././././././././././././././././././././
    wire [2:0] funct3;
    wire [1:0] aluop;
    wire ALUsrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch; // control signals
    wire [6:0] opcode;
    assign opcode = ID_Instruction[6:0];
    assign funct3 = ID_Instruction[14:12];
    assign rs1 = ID_Instruction[19:15];
    assign rs2 = ID_Instruction[24:20];
    assign rd = ID_Instruction[11:7];
    ControlUnit ControlUnit_uut(   // decodes opcode and generates control s/gs
        .opcode(opcode),
        .ALUSrc(ALUsrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .ALUOp(aluop)
    );
    wire ALUsrc_final, MemtoReg_final, RegWrite_final, MemRead_final, MemWrite_final, Branch_final;
    wire [1:0] aluop_final;
    wire ControlMux;
    assign ALUsrc_final = (ControlMux) ? 1'b0 : ALUsrc;
    assign MemtoReg_final = (ControlMux) ? 1'b0 : MemtoReg;
    assign RegWrite_final = (ControlMux) ? 1'b0 : RegWrite;
    assign MemRead_final = (ControlMux) ? 1'b0 : MemRead;
    assign MemWrite_final = (ControlMux) ? 1'b0 : MemWrite;
    assign Branch_final = (ControlMux) ? 1'b0 : Branch;
    assign aluop_final = (ControlMux) ? 2'b00 : aluop;
    ////////////////////////////////////////////////////////////////////////////////////////////////////////



    //  REGISTER FILE  /././././././././././././././././././././././././././././././././././././././././././
    wire [4:0] rs1, rs2, rd;    // register addresses
    wire [63:0] readdata, read1, read2, write_data, alu_result;
    registerfile registerfile_uut(  // contains registers and handles read and write
        .Read1(rs1),
        .Read2(rs2),
        .WriteReg(WB_Rd),
        .WriteData(final_write_data), 
        .RegWrite(WB_RegWrite), 
        .clk(clk),
        .Data1(read1),
        .Data2(read2)
    );
    /////////////////////////////////////////////////////////////////////////////////////////////////////////



    //  IMMEDIATE GENERATE BLOCK  /./././././././././././././././././././././././././././././././././././././
    wire [63:0] immediate;
    immGenerator immGenerator_uut(  // extracts imm from instruction and generates sign extended immediate value
        .instr(ID_Instruction),
        .immOut(immediate)
    );
    wire [63:0] EX_PC;
    wire [31:0] EX_Instruction;
    wire [63:0] EX_ReadData1, EX_ReadData2;
    wire [63:0] EX_Immediate;
    wire [4:0] EX_Rs1, EX_Rs2, EX_Rd;
    wire EX_ALUSrc;
    wire EX_MemtoReg, EX_RegWrite, EX_MemRead, EX_MemWrite, EX_Branch;
    wire [2:0] EX_func3;
    wire EX_func7;
    wire [1:0] EX_ALUOp;
    ID_EX_Reg ID_EX_Reg_uut(    // ID_EX REGISTER 
        .clk(clk),
        .ID_PC(ID_PC),
        .ID_ReadData1(read1), .ID_ReadData2(read2),
        .ID_Immediate(immediate),
        .ID_Rs1(rs1), .ID_Rs2(rs2), .ID_Rd(rd), 
        .ID_ALUSrc(ALUsrc_final),
        .ID_MemtoReg(MemtoReg_final), .ID_RegWrite(RegWrite_final),
        .ID_MemRead(MemRead_final), .ID_MemWrite(MemWrite_final),
        .ID_Branch(Branch_final), .ID_ALUOp(aluop_final),
        .func3(funct3), .func7(ID_Instruction[30]),
        .EX_PC(EX_PC),
        .EX_ReadData1(EX_ReadData1), .EX_ReadData2(EX_ReadData2),
        .EX_Immediate(EX_Immediate),
        .EX_Rs1(EX_Rs1), .EX_Rs2(EX_Rs2), .EX_Rd(EX_Rd),
        .EX_ALUSrc(EX_ALUSrc), 
        .EX_MemtoReg(EX_MemtoReg), .EX_RegWrite(EX_RegWrite),
        .EX_MemRead(EX_MemRead), .EX_MemWrite(EX_MemWrite),
        .EX_Branch(EX_Branch),
        .EX_func3(EX_func3), .EX_func7(EX_func7),
        .EX_ALUOp(EX_ALUOp),
        .flush(PCsrc)
    );
    /////////////////////////////////////////////////////////////////////////////////////////////////////////



    //  FORWARDING UNIT + ALU CONTROL + ALU  /./././././././././././././././././././././././././././././././
    wire [1:0] ForwardA, ForwardB;
    ForwardingUnit ForwardingUnit_uut(  // forwards data to ALU
        .EX_rs1(EX_Rs1),
        .EX_rs2(EX_Rs2),
        .MEM_rd(MEM_Rd), 
        .WB_rd(WB_Rd), 
        .MEM_RegWrite(MEM_RegWrite),
        .WB_RegWrite(WB_RegWrite),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    wire [63:0] alu_source1, alu_source2;  
    wire [63:0] final_write_data, MEM_ALUResult;
    wire [63:0] buffer;
    mux_3x1 forwardA(ForwardA, EX_ReadData1, final_write_data, MEM_ALUResult, alu_source1);
    mux_3x1 forwardB(ForwardB, EX_ReadData2, final_write_data, MEM_ALUResult, buffer);
    mux_2x1 mux_bhai(EX_ALUSrc, buffer, EX_Immediate, alu_source2);
    wire [3:0] alu_control;
    alu_control_module alu_control_module_uut(  // generates ALU control s/gs
        .funct3(EX_func3),
        .funct7(EX_func7),
        .aluop(EX_ALUOp),
        .alu_code(alu_control)
    );
    wire zero, overflow;        // ALU flags
    alu alu_uut(
        .rs1(alu_source1),
        .rs2(alu_source2),
        .alu_code(alu_control),
        .result(alu_result),
        .zero(zero),
        .overflow(overflow)
    );
    wire [63:0] pc_branch;
    assign pc_branch = EX_Immediate + EX_PC;
    /////////////////////////////////////////////////////////////////////////////////////////////////////////



    //  DATA MEMORY  /./././././././././././././././././././././././././././././././././././././././././././
    wire [63:0] MEM_PC;
    wire [63:0] MEM_ReadData2;
    wire [4:0] MEM_Rd;
    wire MEM_MemtoReg;
    wire MEM_RegWrite;
    wire MEM_MemRead;
    wire MEM_MemWrite;
    wire MEM_Branch;
    wire MEM_Zero;
    EX_MEM_Reg EX_MEM_Reg_uut(      // EX_MEM REGISTER
        .clk(clk),
        .EX_PC(pc_branch),
        .EX_ALUResult(alu_result),
        .EX_ReadData2(buffer),
        .EX_Rd(EX_Rd),
        .EX_MemtoReg(EX_MemtoReg),
        .EX_RegWrite(EX_RegWrite),
        .EX_MemRead(EX_MemRead),
        .EX_MemWrite(EX_MemWrite),
        .EX_Branch(EX_Branch),
        .EX_Zero(zero),
        .MEM_PC(MEM_PC),
        .MEM_ALUResult(MEM_ALUResult),
        .MEM_ReadData2(MEM_ReadData2),
        .MEM_Rd(MEM_Rd),
        .MEM_MemtoReg(MEM_MemtoReg),
        .MEM_RegWrite(MEM_RegWrite),
        .MEM_MemRead(MEM_MemRead),
        .MEM_MemWrite(MEM_MemWrite),
        .MEM_Branch(MEM_Branch),
        .MEM_Zero(MEM_Zero)
    );
    data_mem data_mem_uut(  //handles memory read and write
        .out(readdata),
        .add(MEM_ALUResult),
        .in(MEM_ReadData2),
        .mem_wr(MEM_MemWrite),
        .mem_rd(MEM_MemRead),
        .clk(clk)
    );
    and A1(PCsrc, MEM_Branch, MEM_Zero);  // branch condition
    /////////////////////////////////////////////////////////////////////////////////////////////////////////    



    //  WRITE BACK BLOCK  /./././././././././././././././././././././././././././././././././././././././././
    wire [63:0] WB_ALUResult;
    wire [63:0] WB_ReadData;
    wire [4:0] WB_Rd;
    wire WB_MemtoReg;
    wire WB_RegWrite;   
    MEM_WB_Reg MEM_WB_Reg_uut(      // MEM_WB REGISTER
        .clk(clk),
        .MEM_ALUResult(MEM_ALUResult),
        .readdata(readdata),
        .MEM_Rd(MEM_Rd),
        .MEM_MemtoReg(MEM_MemtoReg),
        .MEM_RegWrite(MEM_RegWrite),
        .WB_ReadData(WB_ReadData),
        .WB_ALUResult(WB_ALUResult),
        .WB_Rd(WB_Rd),
        .WB_MemtoReg(WB_MemtoReg),
        .WB_RegWrite(WB_RegWrite)
    );
    mux_2x1 mux_behen(WB_MemtoReg, WB_ALUResult, WB_ReadData, final_write_data);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////        



    //  HAZARD DETECTION UNIT /./././././././././././././././././././././././././././././././././././././././
    wire IF_ID_Write_inter;   
    HazardDetectionUnit HazardDetectionUnit_uut(
            .EX_MemRead(EX_MemRead),
            .EX_rd(EX_Rd),
            .ID_rs2(rs2),
            .ID_rs1(rs1),
            .PCWrite(PCWrite),
            .IF_ID_Write(IF_ID_Write_inter),
            .ControlMux(ControlMux)
    );
    wire PCsrc_not;
    not n1(PCsrc_not,PCsrc);
    and (IF_ID_Write,IF_ID_Write_inter,PCsrc_not);
    /////////////////////////////////////////////////////////////////////////////////////////////////////////        

endmodule