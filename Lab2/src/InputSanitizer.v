`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:12:15 AM
// Design Name: BCD_Counter
// Module Name: InputSanitizer
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Module to sanitize input from buttons
//////////////////////////////////////////////////////////////////////////////////


module InputSanitizer #(
    parameter CounterWidth = 1,
    parameter DebounceTime = 1
) (
    input  wire [3:0] DataIn,
    input  wire       Clk,
    input  wire       Reset,
    output wire [3:0] DataOut
);
  // Add your code here
  // Debouncer instances for each bit of DataIn
  Debouncer #(
      .CounterWidth(CounterWidth),
      .DebounceTime(DebounceTime)
  ) debouncer0 (
      .DataIn(DataIn[0]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[0])
  );

  Debouncer #(
      .CounterWidth(CounterWidth),
      .DebounceTime(DebounceTime)
  ) debouncer1 (
      .DataIn(DataIn[1]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[1])
  );

  Debouncer #(
      .CounterWidth(CounterWidth),
      .DebounceTime(DebounceTime)
  ) debouncer2 (
      .DataIn(DataIn[2]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[2])
  );

  Debouncer #(
      .CounterWidth(CounterWidth),
      .DebounceTime(DebounceTime)
  ) debouncer3 (
      .DataIn(DataIn[3]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[3])
  );
  // End of your code
endmodule
