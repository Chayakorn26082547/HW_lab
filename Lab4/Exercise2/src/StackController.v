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

  //-------------------------------------------------------------------------
  // Internal Registers
  //-------------------------------------------------------------------------
  // Use a 9-bit stack pointer to count from 0 to 256 elements.
  // When sp = 256 the stack is full.
  reg [8:0] sp;
  
  // Register to hold the last popped value.
  reg [7:0] last_popped;

  //-------------------------------------------------------------------------
  // Synchronous Stack Pointer and Last-Popped Value Update
  //-------------------------------------------------------------------------
  // On RESET, clear the stack pointer and last_popped.
  // On a PUSH (and not POP), if the stack is not full, the value from DataIn
  // will be written into RAM and sp is incremented.
  // On a POP (and not PUSH), if the stack is not empty, the value from RAMDataOut
  // is captured into last_popped and sp is decremented.
  always @(posedge Clk) begin
    if (Reset) begin
      sp          <= 9'd0;
      last_popped <= 8'd0;
    end else begin
      if (Push && !Pop) begin
        if (sp < 9'd256) begin
          sp <= sp + 9'd1;
        end
      end else if (Pop && !Push) begin
        if (sp > 9'd0) begin
          last_popped <= RAMDataOut; // Capture the top-of-stack value
          sp <= sp - 9'd1;
        end
      end
      // If both Push and Pop are pressed simultaneously or neither is pressed,
      // no change is made.
    end
  end

  //-------------------------------------------------------------------------
  // Combinational Block: Generate RAM Interface Signals
  //-------------------------------------------------------------------------
  // When a push is performed, we want to write DataIn into RAM at address sp.
  // Otherwise (on a pop or when idle), we read from RAM at address (sp - 1)
  // (if sp > 0).
  reg       ram_we;
  reg       ram_en;
  reg [7:0] ram_addr;
  reg [7:0] ram_din;

  always @(*) begin
    // Always enable the RAM.
    ram_en = 1'b1;
    if (Push && !Pop && (sp < 9'd256)) begin
      // Push operation: write DataIn to RAM at address sp.
      ram_we   = 1'b1;
      ram_addr = sp[7:0];  // Use the lower 8 bits of the 9-bit pointer
      ram_din  = DataIn;
    end else begin
      // For pop or idle: no write operation.
      ram_we = 1'b0;
      if (sp > 0)
        ram_addr = sp - 9'd1;  // Address of the current top-of-stack
      else
        ram_addr = 8'd0;
      ram_din = 8'd0;
    end
  end

  //-------------------------------------------------------------------------
  // Output Assignments
  //-------------------------------------------------------------------------
  // Drive the external RAM signals from the internal signals.
  assign RAMWriteEnable = ram_we;
  assign RAMEnable      = ram_en;
  assign RAMAddress     = ram_addr;
  assign RAMDataIn      = ram_din;

  // The StackCounter is taken from the stack pointer.
  // If sp reaches 256, we saturate the display value at 8'hFF.
  assign StackCounter = (sp == 9'd256) ? 8'hFF : sp[7:0];
  
  // The StackValue output holds the last popped value.
  assign StackValue   = last_popped;

`ifdef COCOTB_SIM
  initial begin
    $dumpfile("waveform.vcd");  // Name of the dump file
    $dumpvars(0, StackController);  // Dump all variables for the top module
  end
`endif

endmodule
