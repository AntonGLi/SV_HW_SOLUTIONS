module raspredelyator
#(
parameter NUM_BANKS = 3,
parameter SIZE_BANKI = 32,

parameter SHIRINA_BANKI =      $clog2(SIZE_BANKI),
parameter SHIRINA_VSEH_BANOK = $clog2(SIZE_BANKI*NUM_BANKS),

parameter NUM_RD_PORTS = 8 // <8 restriction from arbiter
) (
input  logic [NUM_RD_PORTS -1:0] [SHIRINA_VSEH_BANOK -1:0] adr_cpu,
input  logic [NUM_RD_PORTS -1:0]                           req_cpu,
output logic [NUM_RD_PORTS -1:0]                           gnt_cpu,
output logic [NUM_RD_PORTS -1:0] [                   31:0] rd_cpu,

output logic [NUM_BANKS    -1:0] [NUM_RD_PORTS       -1:0] req_robin,
input  logic [NUM_BANKS    -1:0] [NUM_RD_PORTS       -1:0] gnt_robin,

output logic [NUM_BANKS    -1:0] [SHIRINA_BANKI      -1:0] adr_banki,
input  logic [NUM_BANKS    -1:0] [                   31:0] rd_banki
);

genvar i_gen;

logic [NUM_RD_PORTS -1:0] [NUM_BANKS -1:0] [SHIRINA_BANKI -1:0] adr_banki_syroy;
logic [NUM_RD_PORTS -1:0] [NUM_BANKS -1:0]                      req_robin_syroy;

logic [NUM_RD_PORTS -1:0] [SHIRINA_VSEH_BANOK-1:SHIRINA_BANKI] num_banki;

generate
	for (i_gen=0; i_gen<NUM_RD_PORTS; i_gen++) begin : bankinators
		decoder_adr_v_num_banki
		#(
		.NUM_BANKS(NUM_BANKS),
		.SIZE_BANKI(SIZE_BANKI)
		) bankinator (
		.req_cpu   (req_cpu[i_gen]),
		.ra_cpu    (adr_cpu[i_gen]),
		
		.req_robin (req_robin_syroy[i_gen]),
		.ra_banki  (adr_banki_syroy[i_gen]),
		.num_banki (num_banki[i_gen])
		);
	end
endgenerate

integer num_banki_for;
integer num_port_for;

always_comb begin
	adr_banki = '0;
	gnt_cpu   = '0;
	rd_cpu    = '0;

	for (num_port_for=0; num_port_for<NUM_RD_PORTS; num_port_for++) begin

		for (num_banki_for=0; num_banki_for<NUM_BANKS; num_banki_for++) begin
			req_robin [num_banki_for] [num_port_for] = req_robin_syroy [num_port_for] [num_banki_for];
			if (gnt_robin[num_banki_for][num_port_for]) begin
				adr_banki[num_banki_for] = adr_banki_syroy[num_port_for][num_banki_for];
				rd_cpu   [num_port_for]  = rd_banki[num_banki_for];
			end
		end

		gnt_cpu[num_port_for] = gnt_robin [num_banki[num_port_for]] [num_port_for];

	end
end


endmodule

