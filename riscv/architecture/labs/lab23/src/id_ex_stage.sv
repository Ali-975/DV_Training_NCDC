`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/01/2025 04:17:22 PM
// Design Name: rv32i pipelined core
// Module Name: id_ex_stage
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module id_ex_stage(
    input logic clk,
    input logic rst,
    input logic stall,
    input logic flush,
    
    input logic [6: 0] if_id_opcode,
    
    output logic [6: 0] id_ex_opcode,
    
    // register file
    input logic [31: 0] reg_out_1,
    input logic [31: 0] reg_out_2,
    input logic [4: 0] if_id_rs1,
    input logic [4: 0] if_id_rs2,
    input logic [4: 0] if_id_rd,
    
    output logic [31: 0] id_ex_reg_out_1,
    output logic [31: 0] id_ex_reg_out_2,
    output logic [4: 0] id_ex_rs1,
    output logic [4: 0] id_ex_rs2,
    output logic [4: 0] id_ex_rd,
    
    // immediate
    input logic [31: 0] imm,
    
    output logic [31: 0] id_ex_imm,
    
    // control unit
    input logic reg_we,
    input logic mem_we,
    input logic mem_re,
    input logic mem_reg_w,
    input logic [1: 0] alu_op,
    input logic op_b_sel,
    input logic [1: 0] op_a_sel,
    input logic [1: 0] pc_sel,
    input logic jump,
    input logic branch,
    
    output logic id_ex_reg_we,
    output logic id_ex_mem_we,
    output logic id_ex_mem_re,
    output logic id_ex_mem_reg_w,
    output logic [1: 0] id_ex_alu_op,
    output logic id_ex_op_b_sel,
    output logic [1: 0] id_ex_op_a_sel,
    output logic [1: 0] id_ex_pc_sel,
    output logic id_ex_jump,
    output logic id_ex_branch,
    
    // alu
    input logic [2: 0] if_id_func_3,
    input logic [6: 0] if_id_func_7,
    
    output logic [2: 0] id_ex_func_3,
    output logic [6: 0] id_ex_func_7,
    
    // prog cntr output
    input logic [31: 0] if_id_pc,
    
    output logic [31: 0] id_ex_pc
);
    
    always_ff @(posedge clk or posedge rst) begin 
        if (rst) begin
            id_ex_opcode    <= 0;
            id_ex_reg_out_1 <= 0;
            id_ex_reg_out_2 <= 0;
            id_ex_rs1       <= 0;
            id_ex_rs2       <= 0;
            id_ex_rd        <= 0;
            id_ex_imm       <= 0;
            id_ex_reg_we    <= 0;
            id_ex_mem_we    <= 0;
            id_ex_mem_re    <= 0;
            id_ex_mem_reg_w <= 0;
            id_ex_alu_op    <= 0;
            id_ex_op_b_sel  <= 0;
            id_ex_op_a_sel  <= 0;
            id_ex_pc_sel    <= 0;
            id_ex_jump      <= 0;
            id_ex_branch    <= 0;
            id_ex_func_3    <= 0;
            id_ex_func_7    <= 0;
            id_ex_pc        <= 0;
        end
        else begin
            if (stall) begin
                id_ex_opcode    <= id_ex_opcode;
                
                // REGISTER FILE
                id_ex_reg_out_1 <= id_ex_reg_out_1;
                id_ex_reg_out_2 <= id_ex_reg_out_2;
                id_ex_rs1       <= id_ex_rs1;
                id_ex_rs2       <= id_ex_rs2;
                id_ex_rd        <= id_ex_rd;
                
                // IMMEDIATE
                id_ex_imm       <= id_ex_imm;
                
                // CONTROL UNIT
                id_ex_reg_we    <= id_ex_reg_we;
                id_ex_mem_we    <= id_ex_mem_we;
                id_ex_mem_re    <= id_ex_mem_re;
                id_ex_mem_reg_w <= id_ex_mem_reg_w;
                id_ex_alu_op    <= id_ex_alu_op;
                id_ex_op_b_sel  <= id_ex_op_b_sel;
                id_ex_op_a_sel  <= id_ex_op_a_sel;
                id_ex_pc_sel    <= id_ex_pc_sel;
                id_ex_jump      <= id_ex_jump;
                id_ex_branch    <= id_ex_branch;
                
                // ALU
                id_ex_func_3    <= id_ex_func_3;
                id_ex_func_7    <= id_ex_func_7;
                
                // PROGRAM COUNTER
                id_ex_pc        <= id_ex_pc;
            end
            else if (flush) begin
                id_ex_opcode    <= 0;
                id_ex_reg_out_1 <= 0;
                id_ex_reg_out_2 <= 0;
                id_ex_rs1       <= 0;
                id_ex_rs2       <= 0;
                id_ex_rd        <= 0;
                id_ex_imm       <= 0;
                id_ex_reg_we    <= 0;
                id_ex_mem_we    <= 0;
                id_ex_mem_re    <= 0;
                id_ex_mem_reg_w <= 0;
                id_ex_alu_op    <= 0;
                id_ex_op_b_sel  <= 0;
                id_ex_op_a_sel  <= 0;
                id_ex_pc_sel    <= 0;
                id_ex_jump      <= 0;
                id_ex_branch    <= 0;
                id_ex_func_3    <= 0;
                id_ex_func_7    <= 0;
                id_ex_pc        <= 0;
            end
            else begin
                id_ex_opcode    <= if_id_opcode;
                
                // REGISTER FILE
                id_ex_reg_out_1 <= reg_out_1;
                id_ex_reg_out_2 <= reg_out_2;
                id_ex_rs1       <= if_id_rs1;
                id_ex_rs2       <= if_id_rs2;
                id_ex_rd        <= if_id_rd;
                
                // IMMEDIATE
                id_ex_imm       <= imm;
                
                // CONTROL UNIT
                id_ex_reg_we    <= reg_we;
                id_ex_mem_we    <= mem_we;
                id_ex_mem_re    <= mem_re;
                id_ex_mem_reg_w <= mem_reg_w;
                id_ex_alu_op    <= alu_op;
                id_ex_op_b_sel  <= op_b_sel;
                id_ex_op_a_sel  <= op_a_sel;
                id_ex_pc_sel    <= pc_sel;
                id_ex_jump      <= jump;
                id_ex_branch    <= branch;
                
                // ALU
                id_ex_func_3    <= if_id_func_3;
                id_ex_func_7    <= if_id_func_7;
                
                // PROGRAM COUNTER
                id_ex_pc        <= if_id_pc;
            end
        end
    end
endmodule
