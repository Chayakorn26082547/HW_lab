`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:12:30 AM
// Design Name: BCD_Counter
// Module Name: SinglePulser
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Single Pulser Module
//////////////////////////////////////////////////////////////////////////////////


module SinglePulser (
    input  wire DataIn,
    input  wire Clk,
    input  wire Reset,
    output wire DataOut
);
  // Add your code here
  reg prev_DataIn; // Register to store the previous state of DataIn
  reg dataOut;
  assign DataOut = dataOut;

  always @(posedge Clk) begin
      if (Reset) begin
          prev_DataIn <= 0; 
          dataOut <= 0;     
      end else begin
          dataOut <= DataIn & ~prev_DataIn;
          prev_DataIn <= DataIn;
      end
  end
  // End of your code
endmodule
