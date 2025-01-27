`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:16:12 AM
// Design Name: BCD_Counter
// Module Name: SevenSegmentDisplay
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Top module for 7-Segment Display
//////////////////////////////////////////////////////////////////////////////////


module SevenSegmentDisplay #(
    parameter ControllerClockCycle   = 1,
    parameter ControllerCounterWidth = 1
) (
    input wire [15:0] DataIn,
    input wire Clk,
    input wire Reset,
    output wire [7:0] Segments,
    output wire [3:0] AN
);
  wire [1:0] selector;
  wire [3:0] dataOut;
  // Add your code here
  Multiplexer Multi(
    .DataIn(DataIn),
    .Selector(selector),
    .DataOut(dataOut)
  );

  SevenSegmentController #(
    .ControllerClockCycle(ControllerClockCycle),
    .ControllerCounterWidth(ControllerCounterWidth)
  ) SevenControl(
    .AN(AN),
    .Reset(Reset),
    .Clk(Clk),
    .Selector(selector)
  );

  SevenSegmentDecoder SevenDecode(
    .DataIn(dataOut),
    .Segments(Segments)
  );
  // End of your code
endmodule
