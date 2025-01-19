`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/09/2025 03:29:42 PM
// Design Name: BCD_Counter
// Module Name: SingleBCDTB
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: The Testbench for the SingleBCD module
//////////////////////////////////////////////////////////////////////////////////


module SingleBCDTB ();
  // reg/wire declaration
  reg        Trigger;
  reg        Reset;
  reg        Clk;
  reg        Cin;
  wire [3:0] DataOut;
  wire       Cout;

  // instantiate the Multiplexer module
  SingleBCD SingleBCDInst (
      .Trigger(Trigger),
      .Clk(Clk),
      .Reset(Reset),
      .Cin(Cin),
      .DataOut(DataOut),
      .Cout(Cout)
  );
  // instantiate variable
  integer flag = 0;
  integer TestCaseNo = 0;
  integer i;
  integer j;

  // task to check the output
  task check_output;
    input integer TestCaseNo;
    input reg [3:0] expected_DataOut;  // Expected output
    input reg expected_Cout;  // Expected output
    begin
      if (DataOut !== expected_DataOut && Cout !== expected_Cout) begin
        $error("ERROR: TestCaseNo %0d | DataOut = %b (Expected: %b) | Cout = %b (Expected: %b)",
               TestCaseNo, $time, DataOut, expected_DataOut, Cout, expected_Cout);
        flag = 1;
      end
    end
  endtask

  localparam CLK_PERIOD = 2;
  always #(CLK_PERIOD / 2.0) Clk = ~Clk;

  // test cases
  initial begin
    // Insert test cases here
    Clk = 0;
    Reset = 0;
    Trigger = 0;
    Cin = 0;
    #(CLK_PERIOD + 0.1);
    
    //Check reset functionality
    Reset = 1;
    #(CLK_PERIOD);
    Reset = 0;
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 4'b000, 1'b0);

    //Check increment functionality
    Trigger = 1;
    Cin = 0;
    for (i = 0; i < 5; i = i + 1) begin
      Reset = 1;
      #(CLK_PERIOD);
      check_output(TestCaseNo++, 4'b000, 1'b0);
      Reset = 0;
      for (j = 0; j < 29; j = j + 1) begin
        #(CLK_PERIOD);
        check_output(TestCaseNo++, (j+1)%10, ((i+1) % 10 == 0 and (i+1) != 0));
      end
    end

    Reset = 1;
    #(CLK_PERIOD);
    Reset = 0;
    //Carry in functionality
    Cin = 1'b1;
    #(CLK_PERIOD);
    check_output(TestCaseNo++, 4'b0001, 1'b0);

    
    if (flag == 0) begin
      $display("All test cases pass");
    end else begin
      $display("Some test cases fail");
    end
    $finish;
  end
endmodule
