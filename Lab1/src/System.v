`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/23/2024 04:13:37 AM
// Design Name: Exercise1
// Module Name: System
// Project Name: Exercise1
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: the top level module
//////////////////////////////////////////////////////////////////////////////////


module System (
    input  wire [7:0] SW,
    input  wire       Reset,
    input  wire       Clk,
    output wire [7:0] Segments,
    output wire [3:0] AN
);

  Controller ControllerInst (
      .Reset(),
      .Clk(),
      .AN(),
      .Selector()
  );
  SevenSegmentDecoder SevenSegmentDecoderInst (
      .DataIn  (),
      .Segments()
  );
  Multiplexer MultiplexerInst (
      .In0(),
      .In1(),
      .Selector(),
      .DataOut()
  );
  // cocotb dump waveforms
`ifdef COCOTB_SIM
  initial begin
    $dumpfile("waveform.vcd");  // Name of the dump file
    $dumpvars(0, System);  // Dump all variables for the top module
  end
`endif
endmodule
