module korobka_s_bankami
#(
	parameter NUM_BANKS  = 3,
	parameter SIZE_BANKI = 32,

	parameter SHIRINA_BANKI = $clog2(SIZE_BANKI)
) (
input  logic [NUM_BANKS-1:0] [SHIRINA_BANKI-1:0] ra,
output logic [NUM_BANKS-1:0] [             31:0] rd
);

genvar i;

generate
	for (i=0; i<NUM_BANKS; i++) begin : delaem_banki
		instruction_rom #( .SIZE(SIZE_BANKI) ) banka
		(
		.a(ra[i]),
		.rd(rd[i])
		);
	end
endgenerate

endmodule
