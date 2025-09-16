`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Mr Muddassir Ali Siddiqui
// Project Name: Custom Processor
//
// Create Date: 08/19/2025 09:01:01 PM
// Module Name: instruction_memory
// 
//////////////////////////////////////////////////////////////////////////////////


module instruction_memory#(
    parameter IMEM_DEPTH = 4)(
    input  logic [$clog2(IMEM_DEPTH)-1: 0] addr,
    output logic [(IMEM_DEPTH * 2) - 1: 0] instr
);

    logic [(IMEM_DEPTH * 2) - 1: 0] mem [0: IMEM_DEPTH - 1];

    // Initialize memory from binary file
    initial begin
        $readmemb("fib_im.mem", mem);
//        $readmemh("rom_image_hex.mem", mem);
    end

    // Read Combinational
    assign instr = mem[addr];

endmodule
