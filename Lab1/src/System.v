`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
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
  // Internal signals
    wire [3:0] Data0, Data1;      // 4-bit data inputs for the multiplexer
    wire [3:0] SelectedData;      // Output from the multiplexer
    wire       Selector;          // Selector signal from the controller

    assign Data0 = SW[3:0];
    assign Data1 = SW[7:4];

  Controller ControllerInst (
      .Reset(Reset),
      .Clk(Clk),
      .AN(AN),
      .Selector(Selector)
  );
  SevenSegmentDecoder SevenSegmentDecoderInst (
      .DataIn  (SelectedData),
      .Segments(Segments)
  );
  Multiplexer MultiplexerInst (
      .In0(Data0),
      .In1(Data1),
      .Selector(Selector),
      .DataOut(SelectedData)
  );
  // cocotb dump waveforms
`ifdef COCOTB_SIM
  initial begin
    $dumpfile("waveform.vcd");  // Name of the dump file
    $dumpvars(0, System);  // Dump all variables for the top module
  end
`endif
endmodule
