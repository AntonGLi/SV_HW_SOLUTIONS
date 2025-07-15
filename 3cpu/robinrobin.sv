module robinrobin
#(
parameter NUM_BANKS = 3,
parameter SIZE_BANKI = 32,

parameter SHIRINA_BANKI =      $clog2(SIZE_BANKI),
parameter SHIRINA_VSEH_BANOK = $clog2(SIZE_BANKI*NUM_BANKS),

parameter NUM_RD_PORTS = 8 // <8 restriction from arbiter
) (
input clk,
input rst,

input  logic [NUM_BANKS    -1:0] [NUM_RD_PORTS       -1:0] req_robin,
output logic [NUM_BANKS    -1:0] [NUM_RD_PORTS       -1:0] gnt_robin,

input  logic [NUM_BANKS    -1:0] [SHIRINA_BANKI      -1:0] adr_raspredelyator,
output logic [NUM_BANKS    -1:0] [SHIRINA_BANKI      -1:0] adr_v_banku
);

assign adr_v_banku = adr_raspredelyator;

genvar robin_gen;

generate
	for (robin_gen=0; robin_gen<NUM_BANKS; robin_gen++) begin : robin_spam
	round_robin_arbiter_8 robin
	(
	.clk(clk),
	.rst(rst),
	.req({'0,req_robin[robin_gen]}),
	.gnt(gnt_robin[robin_gen])
	);
	end
endgenerate

endmodule
