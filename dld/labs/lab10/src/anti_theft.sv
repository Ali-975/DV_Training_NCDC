`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:21:24 PM
// Design Name: 
// Module Name: anti_theft
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


module anti_theft(
    input logic clk, rst,
    input logic ignition, driver_door, passenger_door,
    input logic timer_expired,
    input logic [3:0] t_arm_delay, t_driver_delay, t_passenger_delay, t_alarm_on,
    output logic start_timer,
    output logic [3:0] timer_value,
    output logic led, siren
);
    typedef enum logic [2:0] {
        DISARMED, 
        WAIT_TO_ARM, 
        ARMED,
        TRIGGERED_DRIVER, 
        TRIGGERED_PASS,
        SOUND_ALARM
    } state_t;
    
    state_t state, next;

    always_ff @(posedge clk or posedge rst)
        if (rst) state <= ARMED;
        else state <= next;

    always_comb begin
        //Default Conditions
        start_timer = 0;
        led = 0;
        siren = 0;
        timer_value = 4'd0;
        next = state;

        case (state)
            DISARMED: begin
                led = 0;
                if (!ignition && driver_door)
                    next = WAIT_TO_ARM;
            end
                    
            WAIT_TO_ARM: begin
                led = 0;
                if (!driver_door && !passenger_door) begin
                    start_timer = 1;
                    timer_value = t_arm_delay;
                    next = ARMED;
                end
            end
                
            ARMED: begin
                led = 1;
                if (driver_door) begin
                    start_timer = 1;
                    timer_value = t_driver_delay;
                    next = TRIGGERED_DRIVER;
                end else if (passenger_door) begin
                    start_timer = 1;
                    timer_value = t_passenger_delay;
                    next = TRIGGERED_PASS;
                end
                end
                
            TRIGGERED_DRIVER: begin
                led = 1;
                if (ignition) next = DISARMED;
                else if (timer_expired) next = SOUND_ALARM;
                end
                
            TRIGGERED_PASS: begin
                led = 1;
                if (ignition) next = DISARMED;
                else if (timer_expired) next = SOUND_ALARM;
                end
                
            SOUND_ALARM: begin
                led = 1; siren = 1;
                if (ignition) next = DISARMED;
                else if (timer_expired) begin
                    start_timer = 1;
                    timer_value = t_arm_delay;
                    next = ARMED;
                end
                end
        endcase
    end
endmodule

