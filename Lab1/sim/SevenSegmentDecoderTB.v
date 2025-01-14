`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12/23/2024 05:07:14 AM
// Design Name: Exercise1
// Module Name: SevenSegmentDecoderTB
// Project Name: Exercise1
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Testbench for the SevenSegmentDecoder module
//////////////////////////////////////////////////////////////////////////////////


module SevenSegmentDecoderTB ();
  // declare the reg/wire
  reg  [3:0] DataIn;
  wire [7:0] Segments;

  // instantiate the SevenSegmentDecoder module
  SevenSegmentDecoder SevenSegmentDecoderInst (
      .DataIn  (DataIn),
      .Segments(Segments)
  );

  // instantiate variable
  integer flag = 0;
  integer TestCaseNo = 0;

  // task to check the output
  task check_output;
    input integer TestCaseNo;
    input reg [7:0] expected_Segments;  // Expected output
    begin
      if (Segments !== expected_Segments) begin
        $error("ERROR: TestCaseNo %0d | Time = %0t | DataIn = %b | Segments = %b (Expected: %b)",
               TestCaseNo, $time, DataIn, Segments, expected_Segments);
        flag = 1;
      end
    end
  endtask

  // test cases
  initial begin
    DataIn = 4'b0000; #1;TestCaseNo = 0; check_output(TestCaseNo, 8'b11000000); // 0
    DataIn = 4'b0001; #1;TestCaseNo = 1; check_output(TestCaseNo, 8'b11111001); // 1
    DataIn = 4'b0010; #1;TestCaseNo = 2; check_output(TestCaseNo, 8'b10100100); // 2
    DataIn = 4'b0011; #1;TestCaseNo = 3; check_output(TestCaseNo, 8'b10110000); // 3
    DataIn = 4'b0100; #1;TestCaseNo = 4; check_output(TestCaseNo, 8'b10011001); // 4
    DataIn = 4'b0101; #1;TestCaseNo = 5; check_output(TestCaseNo, 8'b10010010); // 5
    DataIn = 4'b0110; #1;TestCaseNo = 6; check_output(TestCaseNo, 8'b10000010); // 6
    DataIn = 4'b0111; #1;TestCaseNo = 7; check_output(TestCaseNo, 8'b11111000); // 7
    DataIn = 4'b1000; #1;TestCaseNo = 8; check_output(TestCaseNo, 8'b10000000); // 8
    DataIn = 4'b1001; #1;TestCaseNo = 9; check_output(TestCaseNo, 8'b10010000); // 9
    DataIn = 4'b1010; #1;TestCaseNo = 10; check_output(TestCaseNo, 8'b10001000); // A
    DataIn = 4'b1011; #1;TestCaseNo = 11; check_output(TestCaseNo, 8'b10000011); // B
    DataIn = 4'b1100; #1;TestCaseNo = 12; check_output(TestCaseNo, 8'b11000110); // C
    DataIn = 4'b1101; #1;TestCaseNo = 13; check_output(TestCaseNo, 8'b10100001); // D
    DataIn = 4'b1110; #1;TestCaseNo = 14; check_output(TestCaseNo, 8'b10000110); // E
    DataIn = 4'b1111; #1;TestCaseNo = 15; check_output(TestCaseNo, 8'b10001110); // F
    // your task : complete this testcase

    if (flag == 0) begin
      $display("All test cases pass");
    end else begin
      $display("Some test cases fail");
    end
    $finish;
  end
endmodule
