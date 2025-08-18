`timescale 1ns / 1ps

module tb_uart_top;

    // DUT connections
    logic clk;
    logic rst;
    logic tx_valid;
    logic rx_data;
    logic [7:0] d_in;
    logic [1:0] sel_baud;

    logic tx_data;
    logic tx_status;
    logic rx_status;
    logic [7:0] d_out;

    // Instantiate DUT
    uart dut (
        .clk(clk),
        .sel_baud(sel_baud),
        .d_out(d_out),
        .rx_data(rx_data),
        .rx_status(rx_status),
        .rst(rst),
        .tx_data(tx_data),
        .tx_status(tx_status),
        .d_in(d_in),
        .tx_valid(tx_valid)
    );

    // Clock generation (100 MHz -> period 10ns)
    initial clk = 0;
    always #1 clk = ~clk;  // 500 MHz sim clock (adjust as needed)
    
    assign rx_data = tx_data; // loopback

    // Test procedure
    initial begin
        // Initial conditions
        rst       = 0;
        tx_valid  = 1;   // idle (active-low trigger)
        sel_baud  = 2'b00;
        d_in      = 8'h00;

        // Release reset
        #100 rst = 1;
        #1000; // wait after reset

        // ---- Send 1st byte ----
        wait (tx_status == 0);
        d_in = 8'hA5;
        tx_valid = 1;
        #700000 tx_valid = 0;
        wait (tx_status == 1);
        wait (tx_status == 0);
        #100;

        // ---- Send 2nd byte ----
        wait (tx_status == 0);
        d_in = 8'h3C;
        tx_valid = 1;
        #700000 tx_valid = 0;
        wait (tx_status == 1);
        wait (tx_status == 0);
        #100;

        // ---- Send 3rd byte ----
        wait (tx_status == 0);
        d_in = 8'h7F;
        tx_valid = 1;
        #700000 tx_valid = 0;
        wait (tx_status == 1);
        wait (tx_status == 0);
        #100;

        // ---- Send 4th byte ----
        wait (tx_status == 0);
        d_in = 8'h80;
        tx_valid = 1;
        #700000 tx_valid = 0;
        wait (tx_status == 1);
        wait (tx_status == 0);
        #100;

        // End simulation
        #1000 $finish;
    end

endmodule
