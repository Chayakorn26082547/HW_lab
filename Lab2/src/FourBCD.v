`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:15:10 AM
// Design Name: BCD_Counter
// Module Name: FourBCD
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: The Four Digit BCD Counter Module
//////////////////////////////////////////////////////////////////////////////////


module FourBCD (
    input wire [3:0] Trigger,
    input wire Clk,
    input wire Reset,
    output wire [15:0] DataOut
);
  // Add your code here
  // Internal signals for carry propagation between digits;
  reg carry1, carry2, carry3, carry4;

  // Instantiate 4 SingleBCD counters for each digit
  SingleBCD digit0 (
      .Trigger(Trigger[0]),       // Trigger for digit 0
      .Clk(Clk),                  // System clock
      .Reset(Reset),              // Reset signal
      .Cin(1'b0),                 // No carry-in for the least significant digit
      .DataOut(DataOut[3:0]),     // BCD output for digit 0
      .Cout(carry1)         // Carry-out from digit 0
  );

  SingleBCD digit1 (
      .Trigger(Trigger[1] | carry1), // Trigger for digit 1 or carry-in from digit 0
      .Clk(Clk),                           // System clock
      .Reset(Reset),                       // Reset signal
      .Cin(carry1),                  // Carry-in from digit 0
      .DataOut(DataOut[7:4]),              // BCD output for digit 1
      .Cout(carry2)                  // Carry-out from digit 1
  );

  SingleBCD digit2 (
      .Trigger(Trigger[2] | carry2), // Trigger for digit 2 or carry-in from digit 1
      .Clk(Clk),                           // System clock
      .Reset(Reset),                       // Reset signal
      .Cin(carry2),                  // Carry-in from digit 1
      .DataOut(DataOut[11:8]),             // BCD output for digit 2
      .Cout(carry3)                  // Carry-out from digit 2
  );

  SingleBCD digit3 (
      .Trigger(Trigger[3] | carry3), // Trigger for digit 3 or carry-in from digit 2
      .Clk(Clk),                           // System clock
      .Reset(Reset),                       // Reset signal
      .Cin(carry3),                  // Carry-in from digit 2
      .DataOut(DataOut[15:12]),            // BCD output for digit 3
      .Cout(carry4)                  // Carry-out from digit 3 (not used here)
  );
  
  // End of your code
endmodule
