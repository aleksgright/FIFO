`timescale 1ns / 1ps

module counter_tb;

    reg clk;
    reg reset;
    reg cause;
    wire [2:0] cnt_val;
    
    counter cnt_inst(
        .clk(clk),
        .reset(reset),
        .cause(cause),
        .cnt_val(cnt_val)        
    );
    
    reg [8:0] i;
    reg [2:0] expected_out;
    
    initial begin
        reset = 1;
        #5;
        reset = 0;
        #5;
        expected_out = 0;
        
        for (i =0; i < 32; i = i+1) begin
            cause = i%2;
            expected_out = expected_out + cause;
            clk = 1;
            #5;
            clk = 0;
            #5;
        end
     end
        
     always @(negedge reset)
        if (cnt_val != 0) 
            $error("Reset test failed");
        else
            $display("Reset test passed");
            
     always @(negedge clk)
        if (cnt_val != expected_out) 
            $error("Test %d failed, cnt_val = %d, expected+out = %d", i, cnt_val, expected_out);
        else
            $display("Test %d passed", i);       
        
endmodule
