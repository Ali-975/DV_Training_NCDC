`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: NCDC
// Engineer: Muddassir Ali Siddiqui
// 
// Create Date: 08/27/2025 03:14:51 PM
// Design Name: rv32i core
// Module Name: instr_mem
// Project Name: micore
// 
//////////////////////////////////////////////////////////////////////////////////


module instr_mem(
    input  logic [9: 0] addr,     // 12-bit byte address (PC)
    output logic [31:0] instr
);

    // 1024 words (32-bit each) = 4096 bytes total
    logic [31: 0] mem [0: 2**10 - 1];

//    initial begin
//        // instr.mem must have plain hex (no "0x"), one instruction per line
//        $readmemh("instr.mem", mem);
//    end
    initial begin
        integer i;
            for (i = 0; i < 1024; i++) 
                mem[i] = 32'h00000013; // NOP
            $readmemh("instr.mem", mem);
    end

    
    // Read Combinational
    // Word-aligned read: drop lower 2 bits of byte address
    assign instr = mem[addr[9:2]];

endmodule
