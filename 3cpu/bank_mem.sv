module korobka_s_bankami
#(
parameter NUM_BANK = 3
) (
input  logic [NUM_BANK-1:0] [31:0] ra,
output logic [NUM_BANK-1:0] [31:0] rd
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
