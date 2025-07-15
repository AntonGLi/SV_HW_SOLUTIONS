module raspredelyator
#(
parameter NUM_BANKS = 3,
parameter SIZE_BANKI = 32,

parameter SHIRINA_BANKI =      $clog2(SIZE_BANKI),
parameter SHIRINA_VSEH_BANOK = $clog2(SIZE_BANKI*NUM_BANKS),

parameter NUM_RD_PORTS = 3 // <8 restriction from arbiter
) (
input  logic [SHIRINA_VSEH_BANOK -1:0] adr_cpu,
input  logic [NUM_RD_PORTS       -1:0] req_cpu,
output logic [NUM_RD_PORTS       -1:0] gnt_cpu,

output logic [NUM_BANKS          -1:0] req_robin,
input  logic [NUM_BANKS          -1:0] gnt_robin
);

genvar i_gen;

generate
	
	for (i_gen=0; i_gen<NUM_BANKS; i_gen++)
		decoder_adr_v_num_banki
		
		(
		
		)


endgenerate




endmodule