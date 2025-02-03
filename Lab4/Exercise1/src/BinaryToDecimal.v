`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/15/2025 09:45:18 PM
// Design Name: BinaryToDecimal
// Module Name: BinaryToDecimal
// Project Name: BinaryToDecimal
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: The Top level module for the Binary to Decimal conversion Module.
//              It instantiates a ROM unit that converts a 6-bit binary number into
//              a packed BCD value (stored in an 8-bit number, zero–extended to 16 bits)
//              and a SevenSegmentDisplay unit that drives a four–digit seven–segment display.
//////////////////////////////////////////////////////////////////////////////////

module BinaryToDecimal (
    input  wire       Clk,
    input  wire       Reset,
    input  wire [5:0] DataIn,   // 6-bit binary input to be converted
    output wire [7:0] Segments, // Seven-segment display segments (active low, for example)
    output wire [3:0] AN        // Anode enable signals for each digit
);

  // Internal wire to hold the output from the ROM unit.
  // The ROM outputs a 16-bit value where the lower 8 bits contain the packed BCD
  // (two decimal digits) of the binary input and the upper 8 bits are zero.
  wire [15:0] romData;

  //--------------------------------------------------------------------------
  // Instantiate the ROMUnit
  //--------------------------------------------------------------------------
  // This ROM unit uses the 6-bit DataIn as an address into a table that stores
  // the packed BCD representation of the number. The packed BCD is computed as:
  //   ( (i / 10) * 16 ) + (i % 10)
  // For example:
  //   For i = 63, (6 * 16) + 3 = 99 → 8'h63.
  //
  // Note: Although the ROMUnit’s DataOut is declared as 16 bits, the lower 8 bits
  // contain our two-digit number while the upper 8 bits remain zero.
  ROMUnit rom_inst (
    .Address(DataIn),
    .Clk(Clk),
    .Reset(Reset),
    .DataOut(romData)
  );

  //--------------------------------------------------------------------------
  // Instantiate the SevenSegmentDisplay
  //--------------------------------------------------------------------------
  // This module takes a 16-bit input and multiplexes its 4 nibbles onto a
  // four-digit seven–segment display. In our design the two upper digits will be 0,
  // and the lower two digits will display the packed BCD number (e.g. 63 is 0x63).
  SevenSegmentDisplay ssd_inst (
    .Clk(Clk),
    .Reset(Reset),
    .DataIn(romData),
    .Segments(Segments),
    .AN(AN)
  );

endmodule
