`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 04:44:08 PM
// Design Name: 
// Module Name: receiver
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


module receiver(
    input logic clk,
    input logic rst,
    input logic rx_data,
    
    output logic rx_status,
    output logic [7:0] d_out
);
    
    logic [7:0] data_reg, dout_reg;
    logic [2:0] index;
    
    logic [2:0] sample_count;  // counts 0..7 for oversampling
    
    typedef enum logic [1:0]{
        IDLE = 2'b00,
        START = 2'b01,
        DATA = 2'b11,
        STOP = 2'b10
    } fsm_state;
    
    fsm_state current_state;
    
    always@(posedge clk or negedge rst)begin
        if(!rst)begin
            current_state <= IDLE; 
            index <= 0;
            data_reg <= 8'b00000000;
            dout_reg <= 8'b00000000;
            rx_status <= 1'b0;
            sample_count <= 0;
        end
        else begin
            if (current_state != IDLE) begin
                if (sample_count == 3'd7)
                    sample_count <= 3'd0;
                else
                    sample_count <= sample_count + 1;
            end else begin
                sample_count <= 3'd0; // reset in idle
            end
            case(current_state)
                IDLE:   begin
                    rx_status <= 1'b0;
                    data_reg <= 8'b00000000;
                    index <= 0;
                    if (rx_data == 0)
                        current_state <= START;
                end
                START:  begin
                    rx_status <= 1'b1; 
                    current_state <= (sample_count == 7) ? DATA : START;
                end
                DATA:   begin
                    rx_status <= 1'b1;
                    if (sample_count == 7 && index == 7)
                        current_state <= STOP;
                    else if (sample_count == 7)
                        current_state <= DATA;
                    // Capture data at mid bit (sample_count == 3)
                    if (sample_count == 3'd3) begin
                        data_reg[index] <= rx_data;
                    end
                    // Increment bit index at end of bit period
                    if (sample_count == 3'd7)
                        index <= index + 1;
                end
                STOP:   begin
                    rx_status <= 1'b1;
                    if (sample_count == 3'd3)
                        dout_reg <= data_reg;
                    if (rx_data == 1'b1 && sample_count == 3'd3)
                        current_state <= IDLE;
                end
                default:    begin
                    rx_status <= 1'b0;
                    data_reg <= 8'b00000000;
                    index <= 0;
                end
            endcase
        end
    end
    
    assign d_out = dout_reg;
endmodule

