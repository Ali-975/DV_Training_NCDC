`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/01/2025 04:17:22 PM
// Design Name: rv32i pipelined core
// Module Name: if_id_stage
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module if_id_stage(
    input logic clk,
    input logic rst,
    input logic stall,
    
    // instr mem
    input logic [31: 0] instr,
    
    output logic [6: 0] if_id_opcode,
    output logic [4: 0] if_id_rs1,
    output logic [4: 0] if_id_rs2,
    output logic [4: 0] if_id_rd,
    output logic [2: 0] if_id_func_3,
    output logic [6: 0] if_id_func_7,
    output logic [31: 0] if_id_instr,
    
    // prog cntr
    input logic [31: 0] pc,
    
    output logic [31: 0] if_id_pc
);
    
    
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            if_id_opcode  <= 0;
            if_id_rs1     <= 0;
            if_id_rs2     <= 0;
            if_id_rd      <= 0;
            if_id_func_3  <= 0;
            if_id_func_7  <= 0;
            if_id_instr   <= 0;
            if_id_pc      <= 0;
        end
        else 
            if (stall) begin
//                // instruction decode
//                if_id_opcode  <= instr[6: 0];
//                if_id_rs1     <= instr[19: 15];
//                if_id_rs2     <= instr[24: 20];
//                if_id_rd      <= instr[11: 7];
//                if_id_func_3  <= instr[14: 12];
//                if_id_func_7  <= instr[31: 25];
//                if_id_instr   <= instr;
//                if_id_pc      <= pc;
                // instruction decode
                if_id_opcode  <= if_id_opcode;
                if_id_rs1     <= if_id_rs1;
                if_id_rs2     <= if_id_rs2;
                if_id_rd      <= if_id_rd;
                if_id_func_3  <= if_id_func_3;
                if_id_func_7  <= if_id_func_7;
                if_id_instr   <= if_id_instr;
                if_id_pc      <= if_id_pc;
            end
            else begin
                // instruction decode
                if_id_opcode  <= instr[6: 0];
                if_id_rs1     <= instr[19: 15];
                if_id_rs2     <= instr[24: 20];
                if_id_rd      <= instr[11: 7];
                if_id_func_3  <= instr[14: 12];
                if_id_func_7  <= instr[31: 25];
                if_id_instr   <= instr;
                if_id_pc      <= pc;
            end
    end
endmodule
