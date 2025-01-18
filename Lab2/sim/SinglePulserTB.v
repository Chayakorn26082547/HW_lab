`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/09/2025 03:28:24 PM
// Design Name: BCD_Counter
// Module Name: SinglePulserTB
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: The Testbench for the SinglePulser module
//////////////////////////////////////////////////////////////////////////////////


module SinglePulserTB ();
  // reg/wire declaration
  reg  DataIn;
  reg  Reset;
  reg  Clk;
  wire DataOut;

  // instantiate the Multiplexer module
  SinglePulser SinglePulserInst (
      .DataIn(DataIn),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut)
  );
  // instantiate variable
  integer flag = 0;
  integer TestCaseNo = 0;
  integer i;
  integer j;

  // task to check the output
  task check_output;
    input integer TestCaseNo;
    input reg expected_DataOut;  // Expected output
    begin
      if (DataOut !== expected_DataOut) begin
        $error("ERROR: TestCaseNo %0d | DataOut = %b (Expected: %b)", TestCaseNo, $time, DataOut,
               expected_DataOut);
        flag = 1;
      end
    end
  endtask

  localparam CLK_PERIOD = 2;
  always #(CLK_PERIOD / 2.0) Clk = ~Clk;

  // test cases
  initial begin
    Clk = 0;
    Reset = 1;
    DataIn = 0;
    #(CLK_PERIOD);

    Reset = 0;
    #(CLK_PERIOD);

    // Test Case 1: No pulse when DataIn is 0
    DataIn = 0;
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 0);
    // Test Case 2: Generate pulse when DataIn rises from 0 to 1
    DataIn = 1;
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 1);
    // Test Case 3: No pulse when DataIn remains 1
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 0);
    // Test Case 4: Generate another pulse on a new rising edge
    DataIn = 0;
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 0);
    DataIn = 1;
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 1);
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 0);

    //Test Case 5: Reset signal test
    Reset = 1;
    DataIn = 1;
    #(CLK_PERIOD);
    Reset = 0;
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 0);

    //Test Case 6: for loop test
    for (j = 0; j < 10; j = j + 1) begin
      for (i = 0; i < 10; i = i + 1) begin
        DataIn = 0;
        #(CLK_PERIOD);
        check_output(TestCaseNo++, 0);
        DataIn = 1;
        #(CLK_PERIOD);
        check_output(TestCaseNo++, 1);
        #(CLK_PERIOD);
        check_output(TestCaseNo++, 0);
      end
      Reset = 1;
      #(CLK_PERIOD);
      Reset = 0;
      #(CLK_PERIOD);
      check_output(TestCaseNo++, 0);
  end


    if (flag == 0) begin
      $display("All test cases pass");
    end else begin
      $display("Some test cases fail");
    end
    $finish;
  end
endmodule
