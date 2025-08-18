`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 11:38:27 PM
// Design Name: 
// Module Name: alu_4bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_4bit (
    input  logic [3:0] operand_a,
    input  logic [3:0] operand_b,
    input  logic [3:0] opcode,
    output logic [3:0] result,
    output logic       carry_out,
    output logic       overflow
);
    logic signed [4:0] temp_a, temp_b;
    logic signed [4:0] temp_result;

    always_comb begin
        carry_out = 0;
        overflow = 0;
        result = 4'b0000;

        temp_a = operand_a;
        temp_b = operand_b;

        case (opcode)
            4'd0: begin // Addition
                temp_result = temp_a + temp_b;
                result = temp_result[3:0];
                carry_out = temp_result[4];
                overflow = (temp_a[3] == temp_b[3]) && (result[3] != temp_a[3]);
            end

            4'd1: begin // Subtraction
                temp_result = temp_a - temp_b;
                result = temp_result[3:0];
                carry_out = temp_result[4];
                overflow = (temp_a[3] != temp_b[3]) && (result[3] != temp_a[3]);
            end

            4'd2: begin // 2's Complement
                result = ~operand_a + 1; // (operand_a)
            end

            4'd3: begin // Increment
                result = operand_a + 1; // (operand_a)
            end

            4'd4: begin // Decrement
                result = operand_a - 1; // (operand_a)
            end

            4'd5: begin // 1-bit Left Circular Shift 
                result = {operand_a[2:0], operand_a[3]}; // (operand_a)
            end

            4'd6: result = operand_a | operand_b;  // Bitwise OR
            
            4'd7: result = operand_a & operand_b;  // Bitwise AND
            
            4'd8: result = operand_a ^ operand_b;  // Bitwise XOR

            4'd9: begin // Greater Operand
                result = (operand_a > operand_b) ? operand_a : operand_b; // If a > b result = a otherwise result = b
            end

            4'd10: begin // Output Either Operand (A/B)
                result = operand_a; // I will assign A
            end

            default: result = 4'b0000;
        endcase
    end
endmodule

