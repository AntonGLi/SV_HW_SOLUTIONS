module meme_v_bankah
#(
parameter NUM_BANKS = 3,
parameter SIZE_BANKI = 32,

parameter SHIRINA_BANKI =      $clog2(SIZE_BANKI),
parameter SHIRINA_VSEH_BANOK = $clog2(SIZE_BANKI*NUM_BANKS),

parameter NUM_RD_PORTS = 8 // <8 restriction from arbiter
) (
input clk,
input rst,

input  logic [NUM_RD_PORTS -1:0] [SHIRINA_VSEH_BANOK -1:0] ra,
input  logic [NUM_RD_PORTS -1:0]                           req_cpu,
output logic [NUM_RD_PORTS -1:0]                           gnt_cpu,
output logic [NUM_RD_PORTS -1:0] [                   31:0] rd
);

logic        [NUM_BANKS    -1:0] [SHIRINA_BANKI      -1:0] adr_v_banku;
logic        [NUM_BANKS    -1:0] [                   31:0] rd_banki;
logic        [NUM_RD_PORTS -1:0] [                   31:0] rd_cpu;

logic        [NUM_BANKS    -1:0] [NUM_RD_PORTS       -1:0] req_robin;
logic        [NUM_BANKS    -1:0] [NUM_RD_PORTS       -1:0] gnt_robin;
logic        [NUM_BANKS    -1:0] [SHIRINA_BANKI      -1:0] adr_raspredelyator;



korobka_s_bankami
#(
	.NUM_BANKS(NUM_BANKS),
	.SIZE_BANKI(SIZE_BANKI)
) korobka (
	.ra(adr_v_banku),
	.rd(rd_banki)
);

raspredelyator
#(
	.NUM_BANKS(NUM_BANKS),
	.SIZE_BANKI(SIZE_BANKI),

	.NUM_RD_PORTS(NUM_RD_PORTS) // <8 restriction from arbiter
) main_gowino (
.adr_cpu(ra),
.req_cpu(req_cpu),
.gnt_cpu(gnt_cpu),
.rd_cpu(rd),

.req_robin(req_robin),
.gnt_robin(gnt_robin),

.adr_banki(adr_raspredelyator),
.rd_banki(rd_banki)
);

robinrobin
#(
	.NUM_BANKS(NUM_BANKS),
	.SIZE_BANKI(SIZE_BANKI),

	.NUM_RD_PORTS(NUM_RD_PORTS) // <8 restriction from arbiter
) robin (
.clk(clk),
.rst(rst),

.req_robin(req_robin),
.gnt_robin(gnt_robin),

.adr_raspredelyator(adr_raspredelyator),
.adr_v_banku(adr_v_banku)
);




endmodule


