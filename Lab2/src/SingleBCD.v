`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/01/2025 02:14:43 AM
// Design Name: BCD_Counter
// Module Name: SingleBCD
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: A single BCD counter module for 1 digit in a 4 digit BCD counter
//////////////////////////////////////////////////////////////////////////////////


module SingleBCD (
    input  wire       Trigger,
    input  wire       Clk,
    input  wire       Reset,
    input  wire       Cin,
    output wire [3:0] DataOut,
    output wire       Cout
);
  // Add your code here
  reg [3:0] dataOut = 4'b0000;
  assign DataOut = dataOut;
  assign Cout = (dataOut + (Trigger & ~Reset) + (Cin & ~Reset)) > 4'b1001;

  always @(posedge Clk) begin
    if (Reset) begin
      dataOut <= 4'b0000;
    end else begin
      dataOut <= (dataOut + (Trigger & ~Reset) + (Cin & ~Reset))%10;
    end
  end
  // End of your code
endmodule