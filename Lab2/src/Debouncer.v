`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:11:40 AM
// Design Name: BCD_Counter
// Module Name: Debouncer
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Debouncer module
//////////////////////////////////////////////////////////////////////////////////


module Debouncer #(
    parameter CounterWidth = 1,
    parameter DebounceTime = 1
) (
    input  wire DataIn,
    input  wire Clk,
    input  wire Reset,
    output wire DataOut
);
  // Internal register declarations
  reg [CounterWidth-1:0] Counter; // Counter for debounce timing
  reg dataOut;
  assign DataOut = dataOut;
  // Process for debounce logic
  always @(posedge Clk) begin
    if (Reset) begin
      // Reset all internal states
      Counter <= 0;
      dataOut <= 0;
    end else if (Counter >= DebounceTime - 1) begin
      // Input state is changing, increment the counter
      dataOut <= DataIn;
      Counter <= 0;
    end else begin
        Counter <= Counter + 1;
      end
    end
  // End of your code
endmodule
