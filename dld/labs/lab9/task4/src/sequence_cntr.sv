`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 03:54:51 PM
// Design Name: 
// Module Name: sequence_cntr
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


module clock_divider(
    input logic clk_100MHz,
    input logic rst,
    output logic clk_1hz
);
    logic [25:0] counter;

    always_ff @(posedge clk_100MHz or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_1hz <= 0;
        end else begin
            if (counter == 49_999_999) begin  // toggle every 0.5s for 1Hz
                counter <= 0;
                clk_1hz <= ~clk_1hz;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

module sequence_cntr(
    input  logic clk,
    input  logic rst,
    
    output logic [2:0] count,
    output logic [6:0] seg,
    output logic [7:0] AN
);
    assign AN = 8'b11111110;
    
    logic clk_1hz;
    logic [2:0] current_state, next_state;
    
    //Clock divider instance
    clock_divider c1(.clk_100MHz(clk) , .rst(rst), .clk_1hz(clk_1hz));

    // Sequential block: updates the state on positive clock edge
    always_ff @(posedge clk_1hz or posedge rst) begin
        if (rst)
            current_state <= 4'b0000; // Reset to initial state
        else
            current_state <= next_state;
    end
    
    // Combinational block: defines the next state logic
    always_comb begin
        case (current_state)
            3'b000: begin next_state = 3'b010; seg = 7'b0000001; end// a, b, c, d, e, f
            3'b010: begin next_state = 3'b100; seg = 7'b0010010; end// a, b, d, e, g
            3'b100: begin next_state = 3'b110; seg = 7'b1001100; end// b, c, f, g
            3'b110: begin next_state = 3'b001; seg = 7'b0100000; end// a, c, d, e, f, g
            3'b001: begin next_state = 3'b011; seg = 7'b1001111; end// b, c
            3'b011: begin next_state = 3'b101; seg = 7'b0000110; end// a, b, c, d, g
            3'b101: begin next_state = 3'b111; seg = 7'b0100100; end// a, c, d, f, g
            3'b111: begin next_state = 3'b000; seg = 7'b0001111; end// a, b, c
            default: begin next_state = 3'b000; seg = 7'b1111110; end// For invalid states
        endcase
    end

    // Output logic
    assign count = current_state;
endmodule