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
    // Current instruction in ID stage
    input logic [6:0] id_opcode, 
    input logic [4:0] id_rs1, 
    input logic [4:0] id_rs2, 
    
    // Previous instruction in EX stage  
    input logic [6:0] id_ex_opcode, 
    input logic [4:0] id_ex_rd,
    input logic id_ex_mem_re, 
    
    // PC for stalling
    input logic [31:0] pc,
    
    output logic stall,
    output logic [31:0] stall_pc
);

    // Load-Use Hazard Detection
    always_comb begin

        stall = 1'b0;
        stall_pc = pc;
        
        // Check if previous instruction (in EX stage) is a LOAD
        if (id_ex_mem_re == 1'b1 && id_ex_rd != 5'b00000) begin
            
            // Check current instruction type and register dependencies
            case (id_opcode)
                7'b0110011: begin // R-type (add, sub, etc.)
                    if (id_ex_rd == id_rs1 || id_ex_rd == id_rs2) begin
                        stall = 1'b1;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b0010011: begin // I-type (addi, slti, etc.)
                    if (id_ex_rd == id_rs1) begin
                        stall = 1'b1;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b0100011: begin // S-type (sw, sh, sb)
                    if (id_ex_rd == id_rs1 || id_ex_rd == id_rs2) begin
                        stall = 1'b1;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b0000011: begin // Load instructions (lw, lh, lb)
                    if (id_ex_rd == id_rs1) begin
                        stall = 1'b1;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b1100011: begin // Branch instructions (beq, bne, etc.)
                    if (id_ex_rd == id_rs1 || id_ex_rd == id_rs2) begin
                        stall = 1'b1;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                7'b1100111: begin // JALR
                    if (id_ex_rd == id_rs1) begin
                        stall = 1'b1;
                        stall_pc = pc; // Keep same PC (don't increment)
                    end
                end
                
                default: begin
                    stall = 1'b0;
                end
            endcase
        end
    end

endmodule
