`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2025 08:59:39 PM
// Design Name: 
// Module Name: top _tb
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


module top_tb;

    logic clk, rst;
    logic [1:0] mode;
    logic s_in;
    logic [3:0] p_in;
    logic load;

    logic s_out;
    logic [3:0] q_out;

    // Instantiate top module
    top uut (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .s_in(s_in),
        .p_in(p_in),
        .load(load),
        .s_out(s_out),
        .q_out(q_out)
    );

// Instantiate all four types
//    siso_shift_reg siso (.clk(clk), .rst(rst), .s_in(s_in), .s_out(s_siso));

//    sipo_shift_reg sipo (.clk(clk), .rst(rst), .s_in(s_in), .q(q_sipo));

//    piso_shift_reg piso (.clk(clk), .rst(rst), .load(load), .p_in(p_in), .s_out(s_piso));

//    pipo_shift_reg pipo (.clk(clk), .rst(rst), .load(load), .p_in(p_in), .q(q_pipo));

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("uni_shift_reg.vcd");
        $dumpvars(0, top_tb);

        // Initialize
        clk = 0; rst = 1; s_in = 0; p_in = 4'b0000; load = 0; mode = 2'b00;
        #10 rst = 0;

        // ====== SISO test ======
        mode = 2'b00;
        s_in = 1;
        repeat (4) begin #10 s_in = ~s_in; end

        // ====== SIPO test ======
        mode = 2'b01;
        s_in = 1;
        repeat (4) begin #10 s_in = ~s_in; end

        // ====== PISO test ======
        mode = 2'b10;
        p_in = 4'b1010;
        load = 1; #10 load = 0;
        repeat (4) #10;

        // ====== PIPO test ======
        mode = 2'b11;
        p_in = 4'b1101;
        load = 1; #10 load = 0; #10;

        $finish;
    end

endmodule

