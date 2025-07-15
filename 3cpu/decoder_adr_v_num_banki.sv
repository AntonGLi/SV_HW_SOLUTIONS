module decoder_adr_v_num_banki
#(
parameter NUM_BANKS = 3,
parameter SIZE_BANKI = 32,

parameter SHIRINA_BANKI =      $clog2(SIZE_BANKI),
parameter SHIRINA_VSEH_BANOK = $clog2(SIZE_BANKI*NUM_BANKS)
) (
input  logic                                              req_cpu,
input  logic [SHIRINA_VSEH_BANOK-1:0]                     ra_cpu,

output logic [NUM_BANKS         -1:0]                     req_robin,
output logic [NUM_BANKS         -1:0] [SHIRINA_BANKI-1:0] ra_banki,
output logic [SHIRINA_VSEH_BANOK - SHIRINA_BANKI    -1:0] num_banki
);

assign num_banki = ra_cpu[SHIRINA_VSEH_BANOK-1:SHIRINA_BANKI];

always_comb begin
	ra_banki  ='0;
	req_robin ='0;
	
	ra_banki  [num_banki] = ra_cpu [SHIRINA_BANKI-1:0];
	req_robin [num_banki] = req_cpu;
end

endmodule
