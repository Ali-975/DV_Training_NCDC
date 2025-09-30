`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/01/2025 04:17:22 PM
// Design Name: rv32i pipelined core
// Module Name: mem_wb_stage
// Project Name: micore
// 


module mem_wb_stage(
    input logic clk,
    input logic rst,
    
    // control unit
    input logic ex_mem_reg_we,
    input logic ex_mem_mem_reg_w,
    
    output logic mem_wb_reg_we,
    output logic mem_wb_mem_reg_w,
    
    // register file
    input logic [4: 0] ex_mem_rd,
    
    output logic [4: 0] mem_wb_rd,
    
    // alu
    input logic [31: 0] ex_mem_result,
    
    output logic [31: 0] mem_wb_result,
    
    // data memory
    input logic [31: 0] d_mem_d_out,
    
    output logic [31: 0] mem_wb_d_mem_d_out
    
//    // prog cntr output
//    input logic [31: 0] ex_mem_pc,
    
//    output logic [31: 0] mem_wb_pc
);
    
    always_ff @(posedge clk or posedge rst) begin 
        if (rst) begin
            mem_wb_rd           <= 0;
            mem_wb_reg_we       <= 0;
            mem_wb_mem_reg_w    <= 0;
            mem_wb_result       <= 0;
            mem_wb_d_mem_d_out  <= 0;
        end
        else begin
            // REGISTER FILE
            mem_wb_rd           <= ex_mem_rd;
            
            // CONTROL UNIT
            mem_wb_reg_we       <= ex_mem_reg_we;
            mem_wb_mem_reg_w    <= ex_mem_mem_reg_w;
            
            // ALU
            mem_wb_result       <= ex_mem_result;
            
            // DATA MEMORY
            mem_wb_d_mem_d_out  <= d_mem_d_out;
        end
    end
endmodule
