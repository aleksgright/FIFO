`timescale 1ns / 1ps

module fifo_tb;

  reg clk, rst, write, read;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire full, empty;

  fifo fifo_1 (
      .clk(clk),
      .reset(rst),
      .write_enb(write),
      .read_enb(read),
      .data_in(data_in),
      .data_out(data_out),
      .full(full),
      .empty(empty)
  );

//  always begin
//      #5 clk = ~clk;
//  end

  //tests
  reg [7:0] i;
  reg [7:0] test_data;
  reg expected_empty, expected_full;

  initial begin
      write = 0;
      read = 0;
      data_in = 8'd0;

      #10 rst = 1;
      #10 rst = 0;
      
      // ���� 1: ������ ������ � FIFO
      for(i = 0; i < 8; i = i + 1) begin
          test_data = i;  
          data_in = test_data;
          write = 1;
          clk = 1;
          #10
          clk = 0;              
          write =0;
          #10
          expected_empty = 0;      // ������� �� �����
          expected_full = (i == 7) ? 1 : 0;  // �� ��������� ����� ������� �����
          if (full != expected_full) begin
              $display("ERROR: Expected full=%b but got full=%b at i=%d", expected_full, full, i);
          end else $display("Test 1 part 1 i=%b passed", i);
          if (empty != expected_empty) begin
              $display("ERROR: Expected empty=%b but got empty=%b at i=%d", expected_empty, empty, i);
          end else $display("Test 1 part 2 i=%b passed", i);
      end

      // ���� 2: ������ ������ �� FIFO
      for(i = 0; i < 8; i = i + 1) begin
          read = 1;                // ��������� ������
          #10 read = 0;            // ��������� ������
          #10;                      // ���� ����

          // �������� ������
          if (data_out != i) begin
              $display("ERROR: Expected data_out=%d but got data_out=%d at i=%d", i, data_out, i);
          end
      end

     
//      // ���� 3: �������� ������������ FIFO
      write = 1; data_in = 8'd9;
      #10 write = 0;  // ������ � ������ �������
      #10;
      if (full == 0) begin
          $display("ERROR: FIFO should be full, but it's not");
      end else $display("Some succsess");
      
      $display ("test 4");
      
//      // ���� 4: �������� ������ ������ ������� 
      #10 read = 1;
      #10 read = 0; 
      #10 if (empty != 1) begin
          $display("ERROR: FIFO should be empty, but it's not");
      end
      
      // ���� 5: �������� ������������ ������������� ������ � ������ (��� �� ����� ��)
      write = 1;          
      read = 1;           
      data_in = 8'd55;    
      #10;                
      write = 0;
      read = 0;
    
      if (data_out != 8'd0) begin
        $display("ERROR: Data read before write is incorrect. Expected previous value but got %d", data_out);
      end

      if (empty != 0 || full != 0) begin
        $display("ERROR: FIFO flags after simultaneous read/write are incorrect. empty=%b, full=%b", empty, full);
      end
      
      $stop;
  end

endmodule
