`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/03/2025 04:00:01 PM
// Design Name: rv32i pipelined core
// Module Name: forwarding_unit
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module forwarding_unit(
    // register file
    input logic [4: 0] id_ex_rs1,
    input logic [4: 0] id_ex_rs2,
    input logic [4: 0] id_ex_rd,
    
    // EX_MEM register file
    input logic [4: 0] ex_mem_rs2,
    input logic [4: 0] ex_mem_rd,
    input logic ex_mem_reg_we,
    input logic ex_mem_mem_we,
    input logic ex_mem_mem_re,
    
    // MEM_WB register file
    input logic [4: 0] mem_wb_rd,
    input logic mem_wb_reg_we,
    
    // ALU
    input logic [31: 0] result,
    input logic [31: 0] ex_mem_result,
    
    output logic [1: 0] forward_op_a_sel,
    output logic [1: 0] forward_op_b_sel,
    output logic ldst
    
);
    // forwarding for operand a
    always_comb begin
        if(ex_mem_rd == id_ex_rs1 && ex_mem_reg_we == 1'b1 && id_ex_rs1 != 5'b00000) begin
            if(ex_mem_mem_re)
                forward_op_a_sel = 2'b01; // for load
            else
                forward_op_a_sel = 2'b10; // for alu
        end
        
        else begin
            if(mem_wb_rd == id_ex_rs1 && mem_wb_reg_we == 1'b1 && id_ex_rs1 != 5'b00000)
                forward_op_a_sel = 2'b11; // for wb
            else
                forward_op_a_sel = 2'b00; // by default no forwarding
        end
    end
    
    // forwarding for operand a
    always_comb begin
        if(ex_mem_rd == id_ex_rs2 && ex_mem_reg_we == 1'b1 && id_ex_rs2 != 5'b00000) begin
            if(ex_mem_mem_re)
                forward_op_b_sel = 2'b01; // for load
            else
                forward_op_b_sel = 2'b10; // for alu
        end
        else begin
            if(mem_wb_rd == id_ex_rs2 && mem_wb_reg_we == 1'b1 && id_ex_rs2 != 5'b00000)
                forward_op_b_sel = 2'b11;// for wb
            else
                forward_op_b_sel = 2'b00;// by default no forwarding
        end
    end
    
endmodule
