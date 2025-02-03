`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/16/2025 01:45:55 AM
// Design Name: StackCircuit
// Module Name: StackUnit
// Project Name: StackCircuit
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: The Module that implement the Stack
//////////////////////////////////////////////////////////////////////////////////

module StackUnit (
    input wire Clk,
    input wire Reset,
    input wire [7:0] DataIn,
    input wire Push,
    input wire Pop,
    output wire [7:0] StackValue,
    output wire [7:0] StackCounter
);
  // Add your code here
  wire ramWrite, ramEnable;
  wire [7:0] ramAddress, ramDatain;

  StackController stackcontrol(
    .Clk(Clk),
    .Reset(Reset),
    .Push(Push),
    .Pop(Pop),
    .DataIn(DataIn),
    .RAMDataOut(ramDataout),
    .StackCounter(StackCounter),
    .StackValue(StackValue),
    .RAMWriteEnable(ramWrite),
    .RAMEnable(ramEnable),
    .RAMAddress(ramAddress),
    .RAMDataIn(ramDatain)
  );

  wire [7:0] ramDataout;

  RAMUnit ram(
    .Reset(Reset),
    .Clk(Clk),
    .WriteEnable(ramWrite),
    .RamEnable(ramEnable),
    .Address(ramAddress),
    .DataIn(ramDatain),
    .DataOut(ramDataout)
  );
  // End of your code
endmodule
