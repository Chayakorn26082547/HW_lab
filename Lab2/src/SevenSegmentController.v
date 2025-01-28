`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: BCD_Counter
// Module Name: SevenSegmentController
// Project Name: BCD_Counter
// Target Devices: Basys3
// Tool Versions: 2023.2
// Description: Controller module for 7-Segment Display
//////////////////////////////////////////////////////////////////////////////////


module SevenSegmentController #(
    parameter ControllerClockCycle   = 1,
    parameter ControllerCounterWidth = 1
) (
    input  wire       Reset,
    input  wire       Clk,
    output wire [3:0] AN,
    output wire [1:0] Selector
);
  reg [ControllerCounterWidth-1:0] Counter = 0;
  // Add your code here
  reg [1:0] selector;
  reg [3:0] an;

  assign AN = an;
  assign Selector = selector;
  
    always @(posedge Clk) begin
        if (Reset) begin
            Counter <= 0;
            selector <= 2'b00;
            an <= 4'b1111;
        end else begin
            if (Counter >= ControllerClockCycle - 1) begin
                Counter <= 0;
                selector <= selector + 1; // Cycle through digits 0-3
                an <= {an[2:0], an[3]};
            end else begin
                Counter <= Counter + 1;
                an <= (an == 4'b1111) ? 4'b1110 : an;
            end
        end
    end
  // End of your code
endmodule
