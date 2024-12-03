`timescale 1ns / 1ps
module memory #(parameter ADDR_WIDTH = 3, DATA_WIDTH = 8)(
    input [DATA_WIDTH-1:0] data_in,
    input [ADDR_WIDTH-1:0] addr_rd,
    input [ADDR_WIDTH-1:0] addr_wr,
    input clk, read, write, reset,
    output reg [DATA_WIDTH-1:0] data_out
    );
    
    reg i;
    reg [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];
    
    always @(posedge clk, posedge reset)
        if(reset)
            for (i=0; i<2**ADDR_WIDTH-1; i=i+1) begin
                mem[i] <= 0;
            end
        else
            begin
                if (write) mem[addr_wr] <= data_in;
                if (read) data_out <= mem[addr_rd];
            end
    
endmodule
