module cache_testbench;

    localparam string filename = "F:/muddassir_ali_siddiqui/ncdc/riscv/architecture/labs/lab26/tester_files/cache-tester/log/core_access.log"; // Replace with your file name  
    reg clk_i, rst_n_i;
    
    
    reg [15: 0] physical_address[4095: 0];
    reg [11: 0] pa_pointer;
    initial begin 
        $readmemb("F:/muddassir_ali_siddiqui/ncdc/riscv/architecture/labs/lab26/tester_files/cache-tester/init_files/phys_addr_buffer.bin", physical_address);
    end
    wire hit_o;
    wire [31:0] data_o;
    
    // reg hit_temp;
    // reg [31:0] data_temp;
    
    
    int fd;
    int readstatus;
//-----------------------------------------------
//          Instantiate Your Cache Here
//-----------------------------------------------
    cache_fully_associative u_cache (
        .clk_i(clk_i),
        .rst_n_i(rst_n_i),
        .addr_i(physical_address[pa_pointer]),
        .hit_o(hit_o),
        .data_o(data_o)
    );
    
    integer i;
    string f_name;
    
    initial begin
        for (i = 0; i < 256; i++) begin
            string f_name;
            // Adjust path as needed
            $sformat(f_name, "F:/muddassir_ali_siddiqui/ncdc/riscv/architecture/labs/lab26/tester_files/cache-tester/init_files/way%0d.bin", i);
    
            fd = $fopen(f_name,"r");
            readstatus = $fscanf(fd, "%b", u_cache.cache[i]);
            $fclose(fd);
        end
    end
             
//-----------------------------------------------


    function int write_file(string filename);
        int file;
        
        file = $fopen(filename, "w"); // Open file for writing
        if (file == 0) begin
            $display("Error: Unable to open file '%s' for writing", filename);
            return 0;
        end
        return file;
        // Write data to the file
    endfunction

    // Testbench example
    initial begin
        clk_i = 0;
        rst_n_i = 0;
        pa_pointer = 0;
        #5;
        rst_n_i = 1;
        fd = write_file(filename); // Call function to write data to file
        #81920
        $finish();
    end

    initial forever #10 clk_i = ~clk_i;

    always @ (posedge clk_i) begin
        // data_temp <= $urandom();
        // hit_temp <= $urandom();
        // $display("PA: %d ; Accessed Data: %b\n", physical_address[pa_pointer], data_o);
        if (hit_o) begin
            $fwrite(fd, "HIT! ; PA: %0d ; Accessed Data: %032b\n", physical_address[pa_pointer], data_o);
        end
        else begin
            $fwrite(fd, "MISS! ; PA: %0d ; Accessed Data: %0b\n", physical_address[pa_pointer], data_o);
        end
        pa_pointer <= pa_pointer + 1;
        if(pa_pointer == 4096) begin
            $fclose(fd); // Close file
            $finish;
        end
    end

// assign data_o = data_temp;
// assign hit_o  = hit_temp;

endmodule 