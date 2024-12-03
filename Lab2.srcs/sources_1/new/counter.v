`timescale 1ns / 1ps
module counter(
    input wire clk,
    input wire reset,
    input wire cause,
    output reg [2:0] cnt_val
    );
    
    always @(posedge clk, posedge reset)
        if (reset) cnt_val <= 0;
        else begin
        if (cause) cnt_val <= cnt_val + 1;
        end
        
endmodule