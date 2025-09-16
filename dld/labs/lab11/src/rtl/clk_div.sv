`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2025 10:23:45 PM
// Design Name: 
// Module Name: clk_div
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

module clk_div #(parameter COUNT = 50000000)(    
    input logic clk,
    input logic rst,
    output logic q
);
    
    logic [26:0]counter;
    
    always@(posedge clk or negedge rst)begin
        if(!rst)begin
            q <= 1'b0;
            counter <= 0;
        end
        else begin
            if(counter == COUNT -1 )begin
                q <= ~q;
                counter <= 1'b0;
            end
            else
                counter <= counter + 1; 
        end
    end
endmodule
