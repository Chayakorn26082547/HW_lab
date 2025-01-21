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
    DataIn = 0;
    Reset = 0;
    Clk = 0;
    #(CLK_PERIOD + 0.1);
    Reset = 1;
    #(CLK_PERIOD);
    check_output(0, 0);
    Reset = 0;

    // Test DataIn = 0
    DataIn = 0;
    #(CLK_PERIOD);
    check_output(1, 0);

    //Test Rising edge
    DataIn = 1;
    #(CLK_PERIOD);
    check_output(2, 1);
    #(CLK_PERIOD);
    check_output(3, 0);

    DataIn = 0;
    #(CLK_PERIOD);
    check_output(4, 0);

    DataIn = 1;
    #(CLK_PERIOD);
    check_output(5, 1);
    #(CLK_PERIOD);
    check_output(6, 0);

    DataIn = 0;
    #(CLK_PERIOD);
    check_output(7, 0);

    //Test Rest when DataIn = 1
    DataIn = 1;
    Reset = 1;
    #(CLK_PERIOD);
    check_output(8, 0);
    Reset = 0;
    #(CLK_PERIOD);
    check_output(9, 1);

    //Test For Loop
    DataIn = 0;
    #(CLK_PERIOD);
    check_output(10, 0);

    TestCaseNo = 11;
    for (j = 0; j < 5; j = j + 1) begin
      for (i = 0; i < 10; i = i + 1) begin
        DataIn = 1;
        #(CLK_PERIOD);
        check_output(TestCaseNo, 1);
        TestCaseNo = TestCaseNo + 1;

        #(CLK_PERIOD);
        check_output(TestCaseNo, 0);
        TestCaseNo = TestCaseNo + 1;

        DataIn = 0;
        #(CLK_PERIOD);
        check_output(TestCaseNo, 0);
        TestCaseNo = TestCaseNo + 1;
      end
      Reset = 1;
      #(CLK_PERIOD);
      check_output(TestCaseNo, 0);
      TestCaseNo = TestCaseNo + 1;
      Reset = 0;
      #(CLK_PERIOD);
      check_output(TestCaseNo, 0);
      TestCaseNo = TestCaseNo + 1;

    end


    if (flag == 0) begin
      $display("All test cases pass");
    end else begin
      $display("Some test cases fail");
    end
    $finish;
  end
endmodule
