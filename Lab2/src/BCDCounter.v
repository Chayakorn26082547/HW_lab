`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:10:33 AM
// Design Name: BCD_Counter
// Module Name: BCDCounter
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Top module for BCD Counter
//////////////////////////////////////////////////////////////////////////////////


module BCDCounter #(
    // Modify the parameter to match the requirements
    parameter CounterWidth = 40,
    parameter DebounceTime = 10,
    parameter ControllerClockCycle = 800,
    parameter ControllerCounterWidth = 10
) (
    input  wire       Clk,
    input  wire       Reset,
    input  wire [3:0] Trigger,
    output wire [7:0] Segments,
    output wire [3:0] AN
);

  wire [3:0] dataOut;
  wire [15:0] dataOutBCD;
  // Add your code here
  InputSanitizer #(.CounterWidth(CounterWidth), .DebounceTime(DebounceTime)
  ) inputSanitizer (
    .DataIn(Trigger),
    .Clk(Clk),
    .Reset(Reset),
    .DataOut(dataOut)
  );

  FourBCD fourBCD (
    .Trigger(dataOut),
    .Clk(Clk),
    .Reset(Reset),
    .DataOut(dataOutBCD)
  );

  SevenSegmentDisplay #(
    .ControllerClockCycle(ControllerClockCycle),
    .ControllerCounterWidth(ControllerCounterWidth)
  ) sevenSegmentDisplay(
    .DataIn(dataOutBCD),
    .Clk(Clk),
    .Reset(Reset),
    .Segments(Segments),
    .AN(AN)
  );
  // End of your code
endmodule
