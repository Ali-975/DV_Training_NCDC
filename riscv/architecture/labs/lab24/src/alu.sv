`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: alu
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////

module alu_cntrl(
    input logic [1: 0] alu_op,
    input logic [2: 0] func_3,
    input logic [6: 0] func_7,
    
    output logic [3: 0] alu_instr
);
    always_comb begin
        case(alu_op)
            2'b00: alu_instr = 4'b0010;
            2'b01: alu_instr = 4'b0110;
            2'b10: begin
                case(func_3)
                    3'b000: begin
                        if(func_7 == 7'b0100000 && func_7[6] != 1'b1)
                            alu_instr = 4'b0110;        // sub
                        else
                            alu_instr = 4'b0010;        // add
                    end
                    3'b001: alu_instr = 4'b0100;        // sll
                    3'b010: alu_instr = 4'b0101;        // slt
                    3'b011: alu_instr = 4'b0111;        // sltu
                    3'b100: alu_instr = 4'b1001;        // xor
                    3'b101: begin
                        if(func_7 == 7'b0100000)
                            alu_instr = 4'b0011;        // sra
                        else
                            alu_instr = 4'b1000;        // srl
                    end      
                    3'b110: alu_instr = 4'b0001;        // or
                    3'b111: alu_instr = 4'b0000;        // and
                endcase
            end
            
            default: alu_instr = 4'b1111;
        endcase
    end
endmodule

module alu(
    input logic [31: 0] op_1,
    input logic [31: 0] op_2,
    input logic [3: 0] alu_instr,
    input logic [2: 0] func_3,
    
    output logic [3: 0] zero,
    output logic [31: 0] result,
    output logic branch_taken
);
    logic [32: 0] wide_result;
    logic n, z, c, v;
    logic [31: 0] shift_op_2;
    logic [5: 0] shift;
    
    assign shift_op_2 = op_2 & 32'h1F;
    assign shift = shift_op_2[5: 0];
    
    always_comb begin
        case(alu_instr)
            4'b0010: begin
                result = op_1 + op_2;                               // ADD
                wide_result = {1'b0, op_1} + {1'b0, op_2}; 
                
                //carry flag logic
                c = wide_result[32];
                
                // overflow flag 
                // for add: same sign inputs, different sign result
                if ((op_1[31] == op_2[31]) && (wide_result[31] != op_1[31]))
                    v = 1'b1;
                else
                    v = 1'b0;
            end
            4'b0110: begin
                result = op_1 - op_2;                               // SUB
                wide_result = {1'b0, op_1} - {1'b0, op_2};
                
                //carry flag logic
                c = wide_result[32];
                
                // overflow flag 
                // for sub: different sign inputs, result sign != A's sign
                if ((op_1[31] != op_2[31]) && (wide_result[31] != op_1[31]))
                    v = 1'b1;
                else
                    v = 1'b0;
            end
            4'b0100: result = op_1 << shift;                         // SLL (shift left logical)
            4'b0101: result = ($signed(op_1) < $signed(op_2));       // SLT (signed compare)
            4'b0111: result = (op_1 < op_2);                         // SLTU (unsigned compare)
            4'b1001: result = op_1 ^ op_2;                           // XOR
            4'b1000: result = op_1 >> shift;                         // SRL (shift right logical)
            4'b0011: result = $signed(op_1) >>> op_2[4: 0];          // SRA (shift right arithmetic)
            4'b0001: result = op_1 | op_2;                           // OR
            4'b0000: result = op_1 & op_2;                           // AND
            default: result = 32'b0;                                 // Default
        endcase

    end
    always_comb begin
        unique case (func_3)
            3'b000: branch_taken = (z)       ? 1'b1 : 1'b0; // beq
            3'b001: branch_taken = (!z)      ? 1'b1 : 1'b0; // bne
            3'b100: branch_taken = (n != v)  ? 1'b1 : 1'b0; // blt
            3'b101: branch_taken = (n == v)  ? 1'b1 : 1'b0; // bge
            3'b110: branch_taken = !c        ? 1'b1 : 1'b0; // bltu
            3'b111: branch_taken = (c)       ? 1'b1 : 1'b0; // bgeu
            default: branch_taken = 1'b0;
        endcase
    end
                    
    // Zero flag
    assign z = (result == 0) ? 1'b1: 1'b0;

    // Negative flag
    assign n = result[31];
    
    assign zero = {n, z, c, v};
endmodule

