`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/01/2025 04:17:22 PM
// Design Name: rv32i pipelined core
// Module Name: ex_mem_stage
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module ex_mem_stage(
    input logic clk,
    input logic rst,
    
    // alu
    input logic [3: 0] zero,
    input logic [31: 0] result,
    
    output logic [3: 0] ex_mem_zero,
    output logic [31: 0] ex_mem_result,
    
    // register file
    input logic [4: 0] id_ex_rs1,
    input logic [4: 0] id_ex_rs2,
    input logic [4: 0] id_ex_rd,
    input logic [31: 0] id_ex_reg_out_1,
    input logic [31: 0] id_ex_reg_out_2,
    
    output logic [4: 0] ex_mem_rs1,
    output logic [4: 0] ex_mem_rs2,
    output logic [4: 0] ex_mem_rd,
    output logic [31: 0] ex_mem_reg_out_1,
    output logic [31: 0] ex_mem_reg_out_2,
    
    // control unit
    input logic id_ex_reg_we,
    input logic id_ex_mem_we,
    input logic id_ex_mem_re,
    input logic id_ex_mem_reg_w,
    input logic [1: 0] id_ex_pc_sel,
    input logic id_ex_jump,
    input logic id_ex_branch,
    input logic [2: 0] id_ex_func_3,
    
    output logic ex_mem_reg_we,
    output logic ex_mem_mem_we,
    output logic ex_mem_mem_re,
    output logic ex_mem_mem_reg_w,
    output logic [1: 0] ex_mem_pc_sel,
    output logic ex_mem_jump,
    output logic ex_mem_branch,
    output logic [2: 0] ex_mem_func_3,
    
    // prog cntr output
    input logic [31: 0] id_ex_pc,
    
    output logic [31: 0] ex_mem_pc,
    
    // immediate
    input logic [31: 0] id_ex_imm,
    
    output logic [31: 0] ex_mem_imm
    
);
    
    always_ff @(posedge clk or posedge rst) begin 
        if (rst) begin
            ex_mem_reg_out_1 <= 0;
            ex_mem_reg_out_2 <= 0;
            ex_mem_rs1       <= 0;
            ex_mem_rs2       <= 0;
            ex_mem_rd        <= 0;
            ex_mem_reg_we    <= 0;
            ex_mem_mem_we    <= 0;
            ex_mem_mem_re    <= 0;
            ex_mem_mem_reg_w <= 0;
            ex_mem_pc_sel    <= 0;
            ex_mem_jump      <= 0;
            ex_mem_branch    <= 0;
            ex_mem_func_3    <= 0;
            ex_mem_zero      <= 0;
            ex_mem_result    <= 0;
            ex_mem_pc        <= 0;
            ex_mem_imm       <= 0;
        end
        else begin
            // REGISTER FILE
            ex_mem_reg_out_1 <= id_ex_reg_out_1;
            ex_mem_reg_out_2 <= id_ex_reg_out_2;
            ex_mem_rs1       <= id_ex_rs1;
            ex_mem_rs2       <= id_ex_rs2;
            ex_mem_rd        <= id_ex_rd;
            
            // CONTROL UNIT
            ex_mem_reg_we    <= id_ex_reg_we;
            ex_mem_mem_we    <= id_ex_mem_we;
            ex_mem_mem_re    <= id_ex_mem_re;
            ex_mem_mem_reg_w <= id_ex_mem_reg_w;
            ex_mem_pc_sel    <= id_ex_pc_sel;
            ex_mem_jump      <= id_ex_jump;
            ex_mem_branch    <= id_ex_branch;
            ex_mem_func_3    <= id_ex_func_3;
            
            // ALU
            ex_mem_zero      <= zero;
            ex_mem_result    <= result;
            
            // PROGRAM COUNTER
            ex_mem_pc        <= id_ex_pc;
            
            // PROGRAM COUNTER
            ex_mem_imm       <= id_ex_imm;
        end
    end
endmodule
