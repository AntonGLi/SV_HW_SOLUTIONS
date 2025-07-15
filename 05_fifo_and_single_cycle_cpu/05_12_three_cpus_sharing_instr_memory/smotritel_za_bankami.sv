module smotritel_za_bankami
#(
parameter NUM_BANKS = 3,
parameter SIZE_BANKI = 32,

parameter SHIRINA_BANKI =      $clog2(SIZE_BANKI),
parameter SHIRINA_VSEH_BANOK = $clog2(SIZE_BANKI*NUM_BANKS),
parameter NUM_RD_PORTS = 3 // <8 restriction from arbiter
) (
input clk,
input rst,

input  logic [NUM_BANKS-1:0] [SHIRINA_VSEH_BANOK -1:0]   ra_cpu,
output logic [NUM_RD_PORTS-1:0] [                   31:0]   rd_cpu,

input  logic [NUM_RD_PORTS-1:0]                            req_cpu,
output logic [NUM_RD_PORTS-1:0]                            gnt_cpu,

output logic [NUM_BANKS   -1:0] [SHIRINA_BANKI      -1:0] ra_banki,
input  logic [NUM_BANKS   -1:0] [                   31:0] rd_banki
);

genvar i;

generate
	for (i=0; i<NUM_BANKS; i++) begin : robin_spam
	
		round_robin_arbiter_8 robin
		(
		.clk(clk),
		.rst(rst),
	
		.req(req),
		.gnt(gnt)
		);
		
	end

endgenerate



endmodule