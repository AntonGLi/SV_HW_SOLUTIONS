//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe
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

    // Task:
    //
    // Implement a pipelined module formula_1_pipe that computes the result
    // of the formula defined in the file formula_1_fn.svh.
    //
    // The requirements:
    //
    // 1. The module formula_1_pipe has to be pipelined.
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

//wires

wire        sqrt_a_vld; //all (a, b, c) valid

wire [15:0] sqrt_a;
wire [15:0] sqrt_b;
wire [15:0] sqrt_c;

wire [17:0] sum;

reg  [31:0] res_buf;
reg         vld_buf;

wire res_buf_en;

//instances

isqrt sqrt_A
(
    .clk    (clk),
    .rst    (rst),

    .x_vld  (arg_vld),
    .x      (a),

    .y_vld  (sqrt_a_vld),
    .y      (sqrt_a)
);

isqrt sqrt_B
(
    .clk    (clk),
    .rst    (rst),

    .x_vld  (arg_vld),
    .x      (b),

    .y      (sqrt_b)
);

isqrt sqrt_C
(
    .clk    (clk),
    .rst    (rst),

    .x_vld  (arg_vld),
    .x      (c),

    .y      (sqrt_c)
);

//sum

assign sum          = sqrt_a + sqrt_b + sqrt_c;
assign res_buf_en   = sqrt_a_vld;

//out_vld

always_ff @(posedge clk)
begin
    if (rst)
        vld_buf <= 0;
    else
        vld_buf <= sqrt_a_vld;
end

assign res_vld = vld_buf; // !

//out

always_ff @(posedge clk)
begin
    if (rst)
        res_buf <= '0;
    else
        if (res_buf_en)
            res_buf <= { 14'd0, sum };
end

assign res = res_buf; // !

endmodule
