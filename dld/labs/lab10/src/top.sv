`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:21:24 PM
// Design Name: 
// Module Name: top
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


module top(
    // INPUTS
    input logic clk,
    input logic rst,
    input logic driver_door,
    input logic passenger_door,
    input logic ignition,
    input logic hidden_switch,
    input logic brake,
    input logic [1:0] selector,
    input logic [3:0] time_value,
    input logic reprogram,
    
    // OUTPUTS
    output logic fuel_on,
    output logic speaker,
    output logic led,
    output logic siren
);
    logic timer_expired, start_timer;
    logic [3:0] t_arm_delay, t_driver_delay, t_passenger_delay, t_alarm_on;
    logic [3:0] timer_value;

    time_parameters t_p(clk, rst, reprogram, selector, time_value,
                        t_arm_delay, t_driver_delay,
                        t_passenger_delay, t_alarm_on);

    timer tm(clk, rst, start_timer, timer_value, timer_expired);

    anti_theft a_t(clk, rst, ignition, driver_door, passenger_door,
                       timer_expired, t_arm_delay, t_driver_delay, 
                       t_passenger_delay, t_alarm_on,start_timer, 
                       timer_value, led, siren);

    fuel_pump f_p(clk, rst, ignition, hidden_switch, brake, fuel_on);

    siren sir(clk, rst, siren, speaker);
endmodule
