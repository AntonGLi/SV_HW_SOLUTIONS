//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_pipe
#(parameter N = 16)
(
  input         clk,
  input         rst,

  input         arg_vld,
  input  [31:0] a,
  input  [31:0] b,
  input  [31:0] c,

  output        res_vld,
  output [31:0] res
);

logic [31:0] bc;
logic [31:0] abc;

logic        bc_en;
logic        abc_en;

logic [15:0] sqrt_c;
logic [15:0] sqrt_bc;
logic [15:0] sqrt_abc;

logic [17:0] sum_bc;
logic [17:0] sum_abc;

logic        sqrt_c_en;
logic        sqrt_bc_en;
logic        sqrt_abc_en;

logic        sqrt_c_vld;
logic        sqrt_bc_vld;
logic        sqrt_abc_vld;

logic        shreg_small_vld;
logic        shreg_big_vld;

logic        shreg_small_out;
logic        shreg_big_out;

//instances

isqrt sqrt_C
(
  .clk    (clk),
  .rst    (rst),

  .x_vld  (sqrt_c_en),
  .x      (c),

  .y_vld  (sqrt_c_vld),
  .y      (sqrt_c)
);

isqrt sqrt_BC
(
  .clk    (clk),
  .rst    (rst),

  .x_vld  (sqrt_bc_en),
  .x      (bc),

  .y_vld  (sqrt_bc_vld),
  .y      (sqrt_bc)
);

isqrt sqrt_ABC
(
  .clk    (clk),
  .rst    (rst),

  .x_vld  (sqrt_abc_en),
  .x      (abc),

  .y_vld  (sqrt_abc_vld),
  .y      (sqrt_abc)
);

shift_register_with_valid #(.width(32), .depth(N)) shreg_small
(
  .clk(clk),
  .rst(rst),
    
  .in_vld(arg_vld),
  .in_data(b),

  .out_vld(shreg_small_vld),
  .out_data(shreg_small_out)
);

shift_register_with_valid #(.width(32), .depth(2*N+1)) shreg_big
(
  .clk(clk),
  .rst(rst),
  
  .in_vld(arg_vld),
  .in_data(a),
    
  .out_vld(shreg_big_vld),
  .out_data(shreg_big_out)
);

assign sum_bc  = sqrt_c  + shreg_small_out;
assign sum_abc = sqrt_bc + shreg_big_out;


assign sqrt_c = arg_vld;

assign bc_en = sqrt_c_vld;
always_ff @(posedge clk) begin
  if (rst)
    bc <= 0;
  else begin
    if (bc_en)
      bc <= 32' (sum_bc);
  end
end

assign abc_en = sqrt_bc_vld;
always_ff @(posedge clk) begin
  if (rst)
    abc <= 0;
  else begin
    if (abc_en)
      abc <= 32' (sum_abc);
  end
end

always_ff @(posedge clk) begin
  if (rst)
    sqrt_bc_en <= 0;
  else
    sqrt_bc_en <= sqrt_c_vld;
end

always_ff @(posedge clk) begin
  if (rst)
    sqrt_abc_en <= 0;
  else begin
    sqrt_abc_en <= sqrt_bc_vld;
  end
end

assign res     = sqrt_abc;
assign res_vld = sqrt_abc_vld;

endmodule

    // Task:
    //
    // Implement a pipelined module formula_2_pipe that computes the result
    // of the formula defined in the file formula_2_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_2_pipe has to be pipelined.
    //
    // It should be able to accept a new set of arguments a, b and c
    // arriving at every clock cycle.
    //
    // It also should be able to produce a new result every clock cycle
    // with a fixed latency after accepting the arguments.
    //
    // 2. Your solution should instantiate exactly 3 instances
    // of a pipelined isqrt module, which computes the integer square root.
    //
    // 3. Your solution should save dynamic power by properly connecting
    // the valid bits.
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0


