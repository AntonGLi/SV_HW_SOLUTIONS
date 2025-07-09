module put_in_order
# (
    parameter width    = 16,
              n_inputs = 4
)
(
    input                       clk,
    input                       rst,

    input  [ n_inputs - 1 : 0 ] up_vlds,
    input  [ n_inputs - 1 : 0 ]
           [ width    - 1 : 0 ] up_data,

    output                      down_vld,
    output [ width   - 1 : 0 ]  down_data
);


logic [ n_inputs - 1 : 0 ]
      [ width    - 1 : 0 ] data_buf;

logic [ n_inputs - 1 : 0 ] vld_buf;

logic [ n_inputs - 1 : 0 ] cnt;

// buff data, store until read, then invalid or overwrite

integer i;

always_ff @(posedge clk) begin
    if (rst) begin
        data_buf <= '0;
        vld_buf  <= '0;
    end else begin
        for (i=0; i < n_inputs; i++) begin
            if (up_vlds[i] == 1) begin
                data_buf[i] <= up_data[i];
                vld_buf[i]  <= up_vlds[i];
            end else begin
                if (cnt == i)
                    vld_buf[i] <= 0;
            end
        end
    end
end

//point instance, increment address if only data is valid

always_ff @(posedge clk) begin
    if (rst)
        cnt <= '0;
    else begin
        if (vld_buf[cnt] == 1)
            if (cnt == n_inputs - 1)
                cnt <= '0;
            else
                cnt <= cnt + 1'b1;
    end
end

assign down_data = data_buf[cnt];
assign down_vld  = vld_buf [cnt];

endmodule


    // Task:
    //
    // Implement a module that accepts many outputs of the computational blocks
    // and outputs them one by one in order. Input signals "up_vlds" and "up_data"
    // are coming from an array of non-pipelined computational blocks.
    // These external computational blocks have a variable latency.
    //
    // The order of incoming "up_vlds" is not determent, and the task is to
    // output "down_vld" and corresponding data in a round-robin manner,
    // one after another, in order.
    //
    // Comment:
    // The idea of the block is kinda similar to the "parallel_to_serial" block
    // from Homework 2, but here block should also preserve the output order.


