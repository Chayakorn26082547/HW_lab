module InputSanitizer #(
    parameter CounterWidth = 1,
    parameter DebounceTime = 1
) (
    input  wire [3:0] DataIn,
    input  wire       Clk,
    input  wire       Reset,
    output wire [3:0] DataOut
);
  // Internal wires for debounced output
  wire [3:0] debounced;

  // Debouncer instances
  Debouncer #(.CounterWidth(CounterWidth), .DebounceTime(DebounceTime)) debouncer0 (
      .DataIn(DataIn[0]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(debounced[0])
  );

  Debouncer #(.CounterWidth(CounterWidth), .DebounceTime(DebounceTime)) debouncer1 (
      .DataIn(DataIn[1]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(debounced[1])
  );

  Debouncer #(.CounterWidth(CounterWidth), .DebounceTime(DebounceTime)) debouncer2 (
      .DataIn(DataIn[2]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(debounced[2])
  );

  Debouncer #(.CounterWidth(CounterWidth), .DebounceTime(DebounceTime)) debouncer3 (
      .DataIn(DataIn[3]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(debounced[3])
  );

  // SinglePulser instances
  SinglePulser singlePulser0 (
      .DataIn(debounced[0]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[0])
  );

  SinglePulser singlePulser1 (
      .DataIn(debounced[1]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[1])
  );

  SinglePulser singlePulser2 (
      .DataIn(debounced[2]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[2])
  );

  SinglePulser singlePulser3 (
      .DataIn(debounced[3]),
      .Clk(Clk),
      .Reset(Reset),
      .DataOut(DataOut[3])
  );

endmodule
