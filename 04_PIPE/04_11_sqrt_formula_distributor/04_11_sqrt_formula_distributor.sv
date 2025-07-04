module sqrt_formula_distributor
# (
    parameter formula = 1,
              impl    = 1
)
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

localparam N = 50;

// buf reg

logic [31:0] a_buf [0:N-1];
logic [31:0] b_buf [0:N-1];
logic [31:0] c_buf [0:N-1];
	 
logic [N-1:0] a_en;
logic [N-1:0] b_en;
logic [N-1:0] c_en;

logic [N-1:0] vld_buf;

integer a_for;
integer b_for;
integer c_for;

//a, b, c ff

always_ff @(posedge clk) begin
	for (a_for=0; a_for<N; a_for++) begin
		if (rst)
			a_buf[a_for] <= '0;
		else
			if (a_en[a_for])
				a_buf[a_for] <= a;
	end
end

always_ff @(posedge clk) begin
	for (b_for=0; b_for<N; b_for++) begin
		if (rst)
			b_buf[b_for] <= '0;
		else
			if (b_en[b_for])
				b_buf[b_for] <= b;
	end
end

always_ff @(posedge clk) begin
	for (c_for=0; c_for<N; c_for++) begin
		if (rst)
			c_buf[c_for] <= '0;
		else
			if (c_en[c_for])
				c_buf[c_for] <= c;
	end
end

// res select

logic [31:0] res_bus [0:N-1];
logic [N-1:0] res_vld_bus;

	//mux
integer i;
always_comb begin
	res = '0;
	for (i=0; i<N; i++) begin
		if (res_vld_bus[i]) begin
			res = res_bus[i];
		end
	end
end		
		
	//or
always_comb begin
	res_vld = (res_vld_bus > 0);
end

// cntr

localparam N_WIDTH = $clog2(N);

logic [N_WIDTH-1:0] cnt;

logic [N-1:0] sel;

always_ff @(posedge clk) begin
	if (rst) begin
		cnt <= 0;
	end else begin
		if (arg_vld) begin
			cnt <= cnt + 1'b1;
		end else begin
			cnt <= cnt;
		end
	end
end

always_comb begin
	sel 		=  '0;
	sel[cnt] = 1'b1;
end

assign a_en = sel & {N {arg_vld}};
assign b_en = sel & {N {arg_vld}};
assign c_en = sel & {N {arg_vld}};


//vld ff

always_ff @(posedge clk) begin
	if (rst)
		vld_buf <= '0;
	else
		vld_buf <={N {arg_vld}} & sel;
end


// instances

genvar j;

generate

	for (j=0; j<N; j++) begin : isqrt_spam
		formula_1_impl_1_top     inst
		(
		.clk(clk),
		.rst(rst),
		
		.a(a_buf[j]),
		.b(b_buf[j]),
		.c(c_buf[j]),
		.arg_vld(vld_buf[j]),
		
		.res_vld(res_vld_bus[j]),
		.res(res_bus[j])		
		);
	end

endgenerate

endmodule
