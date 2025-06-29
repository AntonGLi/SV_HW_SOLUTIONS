//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_pipe_aware_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);

reg [1:0] arg_cntr;
reg       cnt_en;

assign isqrt_x =  (arg_cntr[1]) ? c : 
                  (arg_cntr[0]) ? b : a;

enum logic [1:0] {
  READY      = 2'b00,
  LOAD_ISQRT = 2'b01,
  WAIT_ISQRT = 2'b10,
  GET_ISQRT  = 2'b11
} state, next_state;

always_comb begin
  next_state  = state;
  cnt_en      = 0;
  isqrt_x_vld = 0;
  res_vld     = 0;

  case(state)
  READY: begin
    if (arg_vld) begin
      cnt_en = 1;
      next_state = LOAD_ISQRT;
      isqrt_x_vld = 1;
    end
  end
  LOAD_ISQRT: begin
    cnt_en = 1;
    isqrt_x_vld = 1;
    if (arg_cntr[1]) begin
      cnt_en = 0;
      next_state = WAIT_ISQRT;
    end
  end
  WAIT_ISQRT: begin
    if (isqrt_y_vld) begin
      next_state = GET_ISQRT;
      cnt_en = 0;
    end
  end
  GET_ISQRT: begin
    cnt_en = 1;
    if (arg_cntr[1]) begin
      res_vld = 1;
      next_state = READY;
    end
  end
  endcase
end

always_ff @(posedge clk) begin
  if (rst)
    state <= READY;
  else
    state <= next_state;
end

always_ff @(posedge clk) begin
  if (rst)
    arg_cntr <= '0;
  else begin
    if (cnt_en)
      arg_cntr <= arg_cntr + 1;
    else
      arg_cntr <= '0;
  end
end

always_ff @(posedge clk) begin
  if (rst)
    res <= '0;
  else begin
    if (isqrt_y_vld)
      res <= res + 32' (isqrt_y);
    else if (state == WAIT_ISQRT || state == READY)
      res <= '0;
  end
end

endmodule


    // Task:
    //
    // Implement a module formula_1_pipe_aware_fsm
    // with a Finite State Machine (FSM)
    // that drives the inputs and consumes the outputs
    // of a single pipelined module isqrt.
    //
    // The formula_1_pipe_aware_fsm module is supposed to be instantiated
    // inside the module formula_1_pipe_aware_fsm_top,
    // together with a single instance of isqrt.
    //
    // The resulting structure has to compute the formula
    // defined in the file formula_1_fn.svh.
    //
    // The formula_1_pipe_aware_fsm module
    // should NOT create any instances of isqrt module,
    // it should only use the input and output ports connecting
    // to the instance of isqrt at higher level of the instance hierarchy.
    //
    // All the datapath computations except the square root calculation,
    // should be implemented inside formula_1_pipe_aware_fsm module.
    // So this module is not a state machine only, it is a combination
    // of an FSM with a datapath for additions and the intermediate data
    // registers.
    //
    // Note that the module formula_1_pipe_aware_fsm is NOT pipelined itself.
    // It should be able to accept new arguments a, b and c
    // arriving at every N+3 clock cycles.
    //
    // In order to achieve this latency the FSM is supposed to use the fact
    // that isqrt is a pipelined module.
    //
    // For more details, see the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm#state_0



