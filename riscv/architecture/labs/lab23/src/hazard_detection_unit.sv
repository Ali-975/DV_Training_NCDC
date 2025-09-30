`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 09/03/2025 04:00:01 PM
// Design Name: rv32i pipelined core
// Module Name: hazard_detection_unit
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module hazard_detection_unit(
    input logic [6:0] if_id_opcode,         // Current instruction opcode
    input logic [4:0] if_id_rs1,            // Current instruction rs1
    input logic [4:0] if_id_rs2,            // Current instruction rs2
    
    input logic [6:0] id_ex_opcode,     // Previous instruction opcode
    input logic [4:0] id_ex_rd,         // Previous instruction destination register
    input logic id_ex_mem_re,           // Previous instruction is a load
    
    input logic branch_taken,
    
    // PC for stalling
    input logic [31:0] pc,
    
    // PC for flushing
    input logic [31:0] id_ex_pc,
    
    output logic stall,
    output logic if_id_flush,
    output logic id_ex_flush,
    output logic [31:0] stall_pc
);

    always_comb begin
    
        // Check if previous instruction (in EX stage) is a LOAD
        if (id_ex_mem_re == 1'b1 && id_ex_rd != 5'b00000) begin
            
            // Check current instruction type and register dependencies
            case (if_id_opcode)
                7'b0110011: begin // R-type
                    if (id_ex_rd == if_id_rs1 || id_ex_rd == if_id_rs2) begin
                        stall = 1'b1;
                        if_id_flush = 1'b0;
                        id_ex_flush = 1'b0;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b0010011: begin // I-type
                    if (id_ex_rd == if_id_rs1) begin
                        stall = 1'b1;
                        if_id_flush = 1'b0;
                        id_ex_flush = 1'b0;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b0100011: begin // S-type
                    if (id_ex_rd == if_id_rs1 || id_ex_rd == if_id_rs2) begin
                        stall = 1'b1;
                        if_id_flush = 1'b0;
                        id_ex_flush = 1'b0;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b0000011: begin // Load instructions
                    if (id_ex_rd == if_id_rs1) begin
                        stall = 1'b1;
                        if_id_flush = 1'b0;
                        id_ex_flush = 1'b0;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b1100011: begin // Branch instructions 
                    if (id_ex_rd == if_id_rs1 || id_ex_rd == if_id_rs2) begin
                        stall = 1'b1;
                        if_id_flush = 1'b0;
                        id_ex_flush = 1'b0;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b1100111: begin // JALR
                    if (id_ex_rd == if_id_rs1) begin
                        stall = 1'b1;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                default: begin
                    stall = 1'b0;
                end
            endcase
        end
        
        // Hazard Detection for branch
        if (branch_taken) begin
            stall = 1'b0;
            if_id_flush = 1'b1;
            id_ex_flush = 1'b1;
            stall_pc = pc; // Keep same PC (don't increment)
        end
        
        // Hazard Detection for jump
        else if(id_ex_opcode == 7'b1101111 || id_ex_opcode == 7'b1100111)begin
            stall = 1'b0;
            if_id_flush = 1'b1;
            id_ex_flush = 1'b1;
            stall_pc = pc; // Keep same PC (don't increment)
        end
        
        else begin
            stall = 1'b0;
            if_id_flush = 1'b0;
            id_ex_flush = 1'b0;
            stall_pc = pc; // Keep same PC (don't increment)
        end
    end
endmodule
