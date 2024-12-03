`timescale 1ns / 1ps
module fifo #(parameter ADDR_WIDTH = 3, DATA_WIDTH = 8)(
    input reset, read_enb, write_enb, clk, 
    input [DATA_WIDTH-1:0] data_in,
    output full, empty,
    output [DATA_WIDTH-1:0] data_out
    );
    
    wire trigger_q_out;
    wire trigger_notq_out;
//    wire empty_check_mux_out;
//    wire full_check_mux_out;
    wire simultanious_check_mux_out;
    wire equality_check_out;
//    wire temp_empty;
//    wire temp_full;
    wire [2:0] write_addr;
    wire [2:0] read_addr;
    
    rs_trigger current_operation_trigger (
    .reset(simultanious_check_mux_out), 
    .set(read_enb), 
    .q(trigger_q_out), 
    .notq(trigger_notq_out));
    
    assign equality_check_out = write_addr == read_addr;
//    assign full_check_mux_out = full? 0 : write_enb;
//    assign empty_check_mux_out = empty? 0 : read_enb;
    assign simultanious_check_mux_out = read_enb? 0 : write_enb;
    assign empty = trigger_q_out & equality_check_out;
    assign full = trigger_notq_out & equality_check_out;

    //rs_triggers instantiation 
    
//    rs_trigger empty_state_trigger(.set(temp_empty), .reset(reset), .q(empty), .notq()); 
//    rs_trigger full_state_trigger(.set(temp_full), .reset(reset), .q(full), .notq()); 
    
    //counters instantiation
    counter read_addr_counter(.clk(clk), .reset(reset), .cause(read_enb), .cnt_val(read_addr));
    counter write_addr_counter(.clk(clk), .reset(reset), .cause(simultanious_check_mux_out), .cnt_val(write_addr));

    memory ram(
    .data_in(data_in), .data_out(data_out),
    .addr_wr(write_addr), .addr_rd(read_addr),
    .clk(clk), .reset(reset),
    .read(read_enb), .write(simultanious_check_mux_out)
    );
    
endmodule
