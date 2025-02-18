`timescale 1ns / 1ps

module skilltest1 (
    input  wire       Clk,
    input  wire       Reset,
    input  wire [3:0] Trigger,
    output wire [3:0] BCD0,
    output wire [3:0] BCD1,
    output wire [3:0] BCD2,
    output wire [3:0] BCD3
);

localparam IDLE = 0, COOLDOWN = 1;
reg [3:0] TriggerReg;
reg [10:0] counter;
reg state, toggle;

always @(posedge Clk) begin
    if (Reset) begin
        TriggerReg <= 0;
        counter <= 0;
        state <= IDLE;
        BCD <= 1;
        toggle <= 0;    
    end else begin
        case (state)
        
            IDLE: begin
                if (Trigger == 0) TriggerReg <= Trigger;
                else if (Trigger != TriggerReg) begin
                    counter <= 0;
                    state <= COOLDOWN;
                    TriggerReg <= Trigger;
                    toggle <= 1;
                end
            end

            COOLDOWN: begin
                if (counter >= 1023) begin
                    state <= IDLE;
                    counter <= 0;
                end
                else counter <= counter + 1;
            end
            
        default : state <= IDLE;
        endcase
    end
end

reg [15:0] BCD;

wire overflow;
assign overflow = (BCD > 9999) ? 1 : 0;

assign BCD0 = (overflow) ? 4'hf : BCD%10;
assign BCD1 = (overflow) ? 4'hf : (BCD/10)%10;
assign BCD2 = (overflow) ? 4'hf : (BCD/100)%10;
assign BCD3 = (overflow) ? 4'hf : (BCD/1000)%10;

always @(posedge Clk) begin
    if (toggle) begin
        if (TriggerReg[0]) BCD <= BCD + 1;
        else if (TriggerReg[1]) BCD <= BCD + 2;
        else if (TriggerReg[2]) BCD <= BCD*2;
        else if (TriggerReg[3]) BCD <= BCD*3;
        toggle <= 0;
    end
end

endmodule