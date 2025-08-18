//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 07/28/2025 08:37:09 PM
//// Design Name: 
//// Module Name: mux_tb
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////
// There are 3 test benches for 3 tasks when i run the particular file i uncomment it 

module tb_task11;
    logic u, v, w, x;
    logic s0, s1;
    logic m;

    task11 uut (
        .u(u), .v(v), .w(w), .x(x),
        .s0(s0), .s1(s1),
        .m(m)
    );

    initial begin
        $dumpfile("task11.vcd");
        $dumpvars(0, tb_task11);

        // Apply all combinations of select and inputs
        for (int i = 0; i < 16; i++) begin
            {u, v, w, x} = i[3:0];
            for (int sel = 0; sel < 4; sel++) begin
                {s1, s0} = sel[1:0];
                #5;
            end
        end

        #10;
        $finish;
    end
endmodule


//module tb_task12;
//    logic u, v, w, x;
//    logic [1:0] s;
//    logic m;

//    task12 uut (
//        .u(u), .v(v), .w(w), .x(x),
//        .s(s),
//        .m(m)
//    );

//    initial begin
//        $dumpfile("task12.vcd");
//        $dumpvars(0, tb_task12);

//        for (int i = 0; i < 16; i++) begin //run for 16 times b/c 16 possible combinations
//            {u, v, w, x} = i[3:0];
//            for (int sel = 0; sel < 4; sel++) begin
//                s = sel[1:0];
//                #5;
//            end
//        end

//        #10;
//        $finish;
//    end
//endmodule

//module tb_task13;
//    logic u, v, w, x;
//    logic [1:0] s;
//    logic m;

//    task13 uut (
//        .u(u), .v(v), .w(w), .x(x),
//        .s(s),
//        .m(m)
//    );

//    initial begin
//        $dumpfile("task13.vcd");
//        $dumpvars(0, tb_task13);

//        for (int i = 0; i < 16; i++) begin
//            {u, v, w, x} = i[3:0];
//            for (int sel = 0; sel < 4; sel++) begin
//                s = sel[1:0];
//                #5;
//            end
//        end

//        #10;
//        $finish;
//    end
//endmodule

