`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2025 09:24:45 PM
// Design Name: 
// Module Name: counter_param
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


module counter_param(A, B, C, D, clk_div_8, rst);
    output logic A, B, C, D;
    input logic clk_div_8, rst;
    
    logic [$clog2(651)-1:0] cntr_A; //for 9600 baudrate  12.5MHz/9600bps
    logic [$clog2(325)-1:0] cntr_B; //for 19200 baudrate
    logic [$clog2(162)-1:0] cntr_C; //for 38400 baudrate
    logic [$clog2(54)-1:0] cntr_D; //for 115200 baudrate
    
    always@(posedge clk_div_8 or negedge rst)begin
        if(!rst)begin
            A <= 1'b0;
            B <= 1'b0;
            C <= 1'b0;
            D <= 1'b0;
            cntr_A <= 1'b0;
            cntr_B <= 1'b0;
            cntr_C <= 1'b0;
            cntr_D <= 1'b0;
        end
        else begin
            if(cntr_A == 651 - 1)begin
                cntr_A <= 0;
                A <= ~A;
            end
            else begin
                cntr_A <= cntr_A + 1;
            end
         
            if(cntr_B == 325 - 1)begin
                cntr_B <= 0;
                B <= ~B;
            end
            else begin
                cntr_B <= cntr_B + 1;
            end
        
            if(cntr_C == 162 - 1)begin
                cntr_C <= 0;
                C <= ~C;
            end
            else begin
                cntr_C <= cntr_C + 1;
            end
        
            if(cntr_D == 54 - 1)begin
                cntr_D <= 0;
                D <= ~D;
            end
            else begin
                cntr_D <= cntr_D + 1;
            end
        end
    end
endmodule