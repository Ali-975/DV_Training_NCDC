`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/09/2025 08:41:04 PM
// Design Name: 
// Module Name: top_tb
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

  // Clock and reset
  logic clk, rst;

  // Inputs to DUT
  logic driver_door, passenger_door;
  logic ignition, hidden_switch, brake;
  logic [1:0] selector;
  logic [3:0] time_value;
  logic reprogram;

  // Outputs from DUT
  logic fuel_on, speaker, led, siren;

  // DUT instantiation
  top dut (
    .clk(clk),
    .rst(rst),
    .driver_door(driver_door),
    .passenger_door(passenger_door),
    .ignition(ignition),
    .hidden_switch(hidden_switch),
    .brake(brake),
    .selector(selector),
    .time_value(time_value),
    .reprogram(reprogram),
    .fuel_on(fuel_on),
    .speaker(speaker),
    .led(led),
    .siren(siren)
  );

  // Clock generation (logical sim - not tied to real time)
  always #5 clk = ~clk; // 10ns period

  initial begin
    // ===== INITIAL SETUP =====
    clk = 0;
    rst = 1;
    driver_door = 0;
    passenger_door = 0;
    ignition = 0;
    hidden_switch = 0;
    brake = 0;
    selector = 2'b00;
    time_value = 4'd0;
    reprogram = 0;

    #20; // reset hold for 2 clock cycles
    rst = 0;

    $display("System initialized");

    // ===== TEST 1: SYSTEM AUTO ARMS AFTER DRIVER DOOR OPEN/CLOSE =====
    $display(">> Test 1: Arming Sequence");

    driver_door = 1; // open
    #100;
    driver_door = 0; // close
    #1600; // represent 16s delay logically

    $display(">> System should be ARMED now");

    // ===== TEST 2: TRIGGER ALARM WITH DRIVER DOOR =====
    $display(">> Test 2: Triggered Driver Door");

    driver_door = 1; // open
    #1800; // represent 18s delay

    $display(">> Siren should be ON now");

    driver_door = 0; // close door
    #1000; // represent alarm ON time

    $display(">> Siren should be OFF, back to armed");

    // ===== TEST 3: DISARM VIA IGNITION BEFORE ALARM =====
    $display(">> Test 3: Disarm before countdown ends");

    driver_door = 1; // open
    #1300; // represent 13s delay

    ignition = 1; // turn on ignition to disarm
    #50;

    $display(">> System should be disarmed now");

    ignition = 0;
    driver_door = 0;
    #500;

    // ===== TEST 4: FUEL PUMP ACTIVATION =====
    $display(">> Test 4: Fuel pump logic");

    ignition = 1;
    #500;

    hidden_switch = 1;
    brake = 1;
    #500;

    $display(">> Fuel pump should be ON");

    // ===== TEST 5: REPROGRAM T_ALARM_ON TO 3 SECONDS =====
    $display(">> Test 5: Reprogram alarm time");

    ignition = 0;
    hidden_switch = 0;
    brake = 0;

    selector = 2'b11;       // T_ALARM_ON
    time_value = 4'd3;      // 3 seconds
    reprogram = 1;
    #50;
    reprogram = 0;

    // Force system to go back to ARMED
    driver_door = 1;
    #50;
    driver_door = 0;
    #600;

    // Trigger alarm again
    driver_door = 1;
    #800; // countdown
    driver_door = 0;
    #300; // should turn off after 3s

    $display(">> Alarm duration should now be 3 seconds");

    $stop;
  end
endmodule

