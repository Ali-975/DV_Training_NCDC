`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:21:24 PM
// Design Name: 
// Module Name: anti_theft_modules
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


// TIME PARAMETERS MODULE
module time_parameters(
    input logic clk,
    input logic rst,
    input logic reprogram,
    input logic [1:0] selector,
    input logic [3:0] time_value,
    
    output logic [3:0] t_arm_delay,
    output logic [3:0] t_driver_delay,
    output logic [3:0] t_passenger_delay,
    output logic [3:0] t_alarm_on
);
    logic [3:0] mem [3:0];

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            mem[0] <= 4'd6;  // ARM_DELAY
            mem[1] <= 4'd8;  // DRIVER_DELAY
            mem[2] <= 4'd15; // PASSENGER_DELAY
            mem[3] <= 4'd10; // ALARM_ON
        end else if (reprogram) begin
            mem[selector] <= time_value;
        end
    end

    assign t_arm_delay = mem[0];
    assign t_driver_delay = mem[1];
    assign t_passenger_delay = mem[2];
    assign t_alarm_on = mem[3];
endmodule

// TIMER MODULE
module timer (
    input logic clk,
    input logic rst,
    input logic start,
    input logic [3:0] time_value,
    
    output logic expired
);
    logic [24:0] clk_div;
    logic one_hz;
    logic [3:0] count;

    always_ff @(posedge clk) begin
        if (rst || start) begin
            clk_div <= 0;
        end
        else begin
            clk_div <= clk_div + 1;
        end

        if (clk_div == 25_000_000 - 1)
            one_hz <= 1;
        else
            one_hz <= 0;
    end

    always_ff @(posedge clk or posedge rst) begin
        if (rst || start)
            count <= time_value;
        else if (one_hz && count != 0)
            count <= count - 1;
    end

    assign expired = (count == 0);
endmodule

// FUEL PUMP MODULE
module fuel_pump (
    input logic clk,
    input logic rst,
    input logic ignition,
    input logic hidden_switch,
    input logic brake,
    
    output logic fuel_on
);
    typedef enum logic [1:0] {OFF, WAIT_UNLOCK, ON} state_t;
    state_t state, next_state;

    always_ff @(posedge clk or posedge rst)
        if (rst) 
            state <= OFF;
        else 
            state <= next_state;

    always_comb begin
        next_state = state;
        fuel_on = 0;

        case (state)
            OFF: begin
                fuel_on = 0;
                if (ignition) begin
                    next_state = WAIT_UNLOCK;
                end
                else begin 
                    next_state = OFF;
                end
            end
            
            WAIT_UNLOCK:begin
                fuel_on = 0;
                if (hidden_switch && brake) begin
                    next_state = ON;
                end
                else begin 
                    next_state = WAIT_UNLOCK;
                end
            end
            
            ON: begin
                fuel_on = 1;
                if (!ignition) begin
                    next_state = OFF;
                end
                else begin 
                    next_state = ON;
                end
            end
        endcase
    end
endmodule

// SIREN MODULE
module siren(
    input logic clk,
    input logic rst,
    input logic siren_on,
    
    output logic speaker
);
    logic [19:0] tone_count;
    logic wave;

    always_ff @(posedge clk or posedge rst)
        if (rst || !siren_on)
            tone_count <= 0;
        else 
            tone_count <= tone_count + 1;

    always_ff @(posedge clk)
        if (tone_count == 0)
            wave <= ~wave;

    assign speaker = wave;
endmodule

// SLOW CLOCK MODULE
module Clock_1Hz(
    input logic clk_100MHz,
    output logic clk_1Hz
);
    // Max count for half-period (toggle rate): 50 million
    localparam integer MAX_COUNT = 50000000;
    logic [25:0] counter; //Bits to count up to 50M

    always_ff @(posedge clk_100MHz) begin
            if (counter == MAX_COUNT - 1) begin
                counter <= 0;
                clk_1Hz <= ~clk_1Hz;
            end 
            else begin
                counter <= counter + 1;
            end
        end
endmodule
