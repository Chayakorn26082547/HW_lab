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
    // your task : complete this testcase

    if (flag == 0) begin
      $display("All test cases pass");
    end else begin
      $display("Some test cases fail");
    end
    $finish;
  end
endmodule
