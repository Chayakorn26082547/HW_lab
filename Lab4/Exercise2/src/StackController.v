`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 01/16/2025 01:45:42 AM
// Design Name: StackCircuit
// Module Name: StackController
// Project Name: StackCircuit
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: This module implements a Stack (LIFO) using an external RAM.
//              - An 8-bit value (from the switches) is pushed onto the stack
//                when the user presses the PUSH button (if the stack is not full).
//              - When the user presses the POP button and the stack is not empty,
//                the top-of-stack value is popped and sent to the display.
//              - The stack can store up to 256 elements.
//              - The StackCounter output shows the current number of elements
//                (saturating at 8'hFF when full), and StackValue holds the last
//                popped value.
//              - The RAM interface signals (RAMWriteEnable, RAMEnable,
//                RAMAddress, RAMDataIn) are generated accordingly.
//////////////////////////////////////////////////////////////////////////////////

module StackController (
    input  wire       Push,            // User push button
    input  wire       Pop,             // User pop button
    input  wire       Clk,
    input  wire       Reset,
    input  wire [7:0] DataIn,          // 8-bit value from the switches
    output wire [7:0] StackCounter,    // Number of elements currently in the stack
    output wire [7:0] StackValue,      // The popped value (to be displayed as two hex digits)
    output wire       RAMWriteEnable,  // Write enable for the external RAM
    output wire       RAMEnable,       // Enable for the external RAM
    output wire [7:0] RAMAddress,      // Address for the RAM access (0 to 255)
    output wire [7:0] RAMDataIn,       // Data input to the RAM
    input  wire [7:0] RAMDataOut       // Data output from the RAM
);

  reg [8:0] sp;
  reg [7:0] popped;

  assign StackValue = popped;
  assign StackCounter = (sp == 9'd256) ? 8'hFF : sp[7:0];

  // Manage Push Pop function
  always @(posedge Clk) begin
    if (Reset) begin
      sp <= 9'b0;
      popped <= 8'd0;
    end else begin
      if (Push && !Pop) begin
        if (sp < 9'd256) begin
          sp <= sp + 1;
        end
      end else if (Pop && !Push) begin
        if (sp > 0) begin  
          popped <= RAMDataOut;
          sp <= sp - 1;
        end
      end
    end
  end


  reg we;
  reg re;
  reg [7:0] addr, dataIn, dataOut;

  assign RAMWriteEnable = we;
  assign RAMEnable = re;
  assign RAMAddress = addr;
  assign RAMDataIn = dataIn;
  assign RAMDataOut = dataOut;

  always @(*) begin
    re = 1;
    if (Push && !Pop && sp < 9'd256) begin
      we = 1;
      addr = sp[7:0];
      dataIn = DataIn; 
    end else begin
      we = 0;
      if (sp > 0) begin
        addr = sp - 1;
      end else begin
        addr = 0;
      end
      dataIn = 0;
    end
  end

`ifdef COCOTB_SIM
  initial begin
    $dumpfile("waveform.vcd");  // Name of the dump file
    $dumpvars(0, StackController);  // Dump all variables for the top module
  end
`endif

endmodule
