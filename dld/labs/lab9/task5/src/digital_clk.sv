`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 03:08:22 PM
// Design Name: 
// Module Name: digital_clk
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
    output logic clk_1Hz
);
    logic [26:0] counter;

    always_ff @(posedge clk_100MHz or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_1Hz <= 0;
        end else begin
            if (counter == 49_999_999) begin  // toggle every 0.5s for 1Hz
                counter <= 0;
                clk_1Hz <= ~clk_1Hz;
            end else begin
                counter <= counter + 1;
            end
        end
    end
endmodule

module seven_segment_display(
    input logic clk,
    input logic [4:0] hours,
    input logic [5:0] minutes,
    input logic [5:0] seconds,
    
    output logic [6:0] seg,
    output logic [7:0] AN
);
    logic [3:0] digit;
    logic [2:0] sel;
    logic [19:0] refresh_counter;

    // Refresh counter (approximately 1 kHz refresh rate)
    always_ff @(posedge clk) begin
        refresh_counter <= refresh_counter + 1;
    end

    assign sel = refresh_counter[19:17]; // cycle through 6 digits

    // Select digit to display
    always_comb begin
        case (sel)
            3'd0: begin AN = 8'b11111110; digit = seconds % 10; end         // sec_ones
            3'd1: begin AN = 8'b11111101; digit = seconds / 10; end         // sec_tens
            3'd2: begin AN = 8'b11111011; digit = minutes % 10; end         // min_ones
            3'd3: begin AN = 8'b11110111; digit = minutes / 10; end         // min_tens
            3'd4: begin AN = 8'b11101111; digit = hours % 10; end           // hr_ones
            3'd5: begin AN = 8'b11011111; digit = hours / 10; end           // hr_tens
            default: begin AN = 8'b11111111; digit = 4'd0; end
        endcase
    end

    // Combinational decoder logic (common cathode)
    always_comb begin
        case (digit)
            4'd0: seg = 7'b0000001; // a, b, c, d, e, f
            4'd1: seg = 7'b1001111; // b, c
            4'd2: seg = 7'b0010010; // a, b, d, e, g
            4'd3: seg = 7'b0000110; // a, b, c, d, g
            4'd4: seg = 7'b1001100; // b, c, f, g
            4'd5: seg = 7'b0100100; // a, c, d, f, g
            4'd6: seg = 7'b0100000; // a, c, d, e, f, g
            4'd7: seg = 7'b0001111; // a, b, c
            4'd8: seg = 7'b0000000; // a, b, c, d, e, f, g
            4'd9: seg = 7'b0000100; // a, b, c, d, f, g
            default: seg = 7'b1111110; // dash
        endcase
    end
endmodule


module digital_clk(
    input logic clk_1Hz,
    input logic rst,
    output logic [5:0] seconds,
    output logic [5:0] minutes,
    output logic [4:0] hours
);
    always_ff @(posedge clk_1Hz or posedge rst) begin
        if (rst) begin
            seconds <= 0;
            minutes <= 0;
            hours <= 0;
        end 
        else begin
            if (seconds == 59) begin
                seconds <= 0;
                if (minutes == 59) begin
                    minutes <= 0;
                    if (hours == 23)
                        hours <= 0;
                    else
                        hours <= hours + 1;
                end 
                else begin
                    minutes <= minutes + 1;
                end
            end 
            else begin
                seconds <= seconds + 1;
            end
        end
    end
endmodule
