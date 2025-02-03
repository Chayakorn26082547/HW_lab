`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/16/2025 01:44:47 AM
// Design Name: StackCircuit
// Module Name: StackCircuit
// Project Name: StackCircuit
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: The Top level module for the Stack Circuit
//////////////////////////////////////////////////////////////////////////////////


module StackCircuit (
    input  wire       Clk,
    input  wire       Reset,
    input  wire       Push,
    input  wire       Pop,
    input  wire [7:0] DataIn,
    output wire [7:0] Segments,
    output wire [3:0] AN
);
  // Add your code here
  wire [1:0] dataInput;

  InputSanitizer input(
    .Reset(Reset),
    .Clk(Clk),
    .DataIn({Push, Pop}),
    .DataOut(dataInput)
  );

  wire [15:0] dataStack;

  StackUnit stack(
    .Reset(Reset),
    .Clk(Clk),
    .Push(dataInput[1]),
    .Pop(dataInput[0]),
    .DataIn(DataIn),
    .StackValue(dataStack[15:8]),
    .StackCounter(dataStack[7:0])
  );

  SevenSegmentDisplay display(
    .Reset(Reset),
    .Clk(Clk),
    .DataIn(dataStack),
    .Segments(Segments),
    .AN(AN)
  );
  // End of your code
endmodule
