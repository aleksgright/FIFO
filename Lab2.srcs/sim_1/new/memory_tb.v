`timescale 1ns / 1ps
module memory_tb #(parameter ADDR_WIDTH = 3, DATA_WIDTH = 8)();
    reg reset, read, write, clk; 
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    reg [ADDR_WIDTH-1:0] addr_rd;
    reg [ADDR_WIDTH-1:0] addr_wr;
    
    memory ram(
    .data_in(data_in), .data_out(data_out),
    .addr_wr(addr_wr), .addr_rd(addr_rd),
    .clk(clk), .reset(reset),
    .read(read), .write(write)
    );
    
    
//    always begin
//      #5 clk = ~clk;
//    end
    
    reg [7:0] i;
    reg [7:0] test_data;
    reg expected_empty, expected_full;
//    assign test_data = data_out;
  
    initial begin
        reset = 1;
        #10
        reset = 0;
        #10
        for (i = 0; i < 2**ADDR_WIDTH-1; i = i +1) begin
            addr_wr = i;
            data_in = i;
            addr_rd = i;
            write = 1;
            clk = 1;
            #10;
            clk = 0;
            #10;
            write = 0;
            read =1;
            clk = 1;
            #10;
            clk = 0;
            #10;
            test_data = data_out;
            read = 0;
            if (test_data != i) $display ("Jopa, data = %b", test_data);
            else $display("fain");
        end
    end
    
    
endmodule
