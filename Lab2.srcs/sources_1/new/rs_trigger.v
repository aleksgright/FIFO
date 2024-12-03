`timescale 1ns / 1ps
module rs_trigger(
    input reset, set,
    output reg q, notq
    );
    
    always @(*)
        begin
            if (reset) begin
                q <= 0;
                notq <= 1;
            end
            else begin
                q <= 1;
                notq <= 0;
            end
        end
       
endmodule
