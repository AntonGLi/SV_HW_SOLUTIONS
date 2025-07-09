//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_fsm
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

    // Task:
    //
    // Implement a module that calculates the formula from the `formula_2_fn.svh` file
    // using only one instance of the isqrt module.
    //
    // Design the FSM to calculate answer step-by-step and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm

enum logic [1:0]
    {
        idle    = 2'd0,
        
        wait_c   = 2'd1,
        wait_bc  = 2'd2,
        wait_abc = 2'd3
    }
    state, next_state;
    
    //------------------------------------------------------------------------
    // Next state and isqrt interface

    always_comb
    begin
        next_state  = state;

        isqrt_x_vld = '0;
        
        isqrt_x     = 'x;  // Don't care

        // This lint warning is bogus because we assign the default value above
        // verilator lint_off CASEINCOMPLETE

        case (state)
        idle:
        begin
            isqrt_x = c;

            if (arg_vld)
            begin
                isqrt_x_vld = '1;
                
                next_state  = wait_c;
            end
        end

        wait_c:
        begin
            isqrt_x = b + 32' (isqrt_y);

            if (isqrt_y_vld)
            begin
                isqrt_x_vld = '1;
                next_state  = wait_bc;
            end
        end

        wait_bc:        
        begin
            isqrt_x = a + 32' (isqrt_y);
        
            if (isqrt_y_vld)
            begin
                isqrt_x_vld = '1;
                next_state  = wait_abc;
            end
        end
        
        wait_abc:
        begin
            if (isqrt_y_vld)
            begin
                next_state  = idle;
            end
        end

        endcase

        // verilator lint_on  CASEINCOMPLETE

    end

    //------------------------------------------------------------------------
    // Assigning next state

    always_ff @ (posedge clk)
        if (rst)
            state <= idle;
        else
            state <= next_state;

    //------------------------------------------------------------------------
    // Accumulating the result

    always_ff @ (posedge clk)
        if (rst)
            res_vld <= '0;
        else
            res_vld <= (state == wait_abc & isqrt_y_vld);

    logic [31:0] res_next;
    
    always_comb
    begin
        res_next = res + 32' (isqrt_y);
    end

    always_ff @ (posedge clk)
        if (state == idle)
            res <= '0;
        else if (isqrt_y_vld)
            res <= isqrt_y;


endmodule
