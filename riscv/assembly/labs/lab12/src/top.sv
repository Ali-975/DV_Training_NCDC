`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Mr Muddassir Ali Siddiqui
// Project Name: Custom Processor
//
// Create Date: 08/19/2025 09:01:01 PM
// Module Name: top
// 
//////////////////////////////////////////////////////////////////////////////////


module top #(
    parameter IMEM_DEPTH = 4,
    parameter REGF_WIDTH = 16,
    parameter ALU_WIDTH = 16,
    parameter PROG_VALUE = 3
)(
    input logic clk,
    input logic rst
);

    // Wires
    logic [1: 0] pc;
    logic [7: 0] instr;
    logic [1: 0] rs1, rs2, rd, opcode;
    logic [15: 0] res_1, res_2, result;

    // Program Counter
    program_counter #(.PROG_VALUE(PROG_VALUE)) prog_cntr (
        .clk(clk),
        .rst(rst),
        .pc(pc)
    );

    // Instruction Memory
    instruction_memory #(.IMEM_DEPTH(IMEM_DEPTH)) instr_mem (
        .addr(pc),
        .instr(instr)
    );

    // Decode instruction
    assign rd     = instr[7:6];
    assign rs2    = instr[5:4];
    assign rs1    = instr[3:2];
    assign opcode = instr[1:0];

    // Register File
    register_file #(.REGF_WIDTH(REGF_WIDTH)) reg_file (
        .clk(clk),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .data_in(result),
        .reg_out_1(res_1),
        .reg_out_2(res_2)
    );

    // ALU
    alu #(.ALU_WIDTH(ALU_WIDTH)) ALU (
        .op1(res_1),
        .op2(res_2),
        .opcode(opcode),
        .result(result)
    );

endmodule
