module mux_adr
#(
parameter NUM_BANKS = 3,
parameter SIZE_BANKI = 32,
parameter NUM_RD_PORTS = 3,

parameter SHIRINA_BANKI = $clog2(SIZE_BANKI)
) (
input  logic [NUM_RD_PORTS-1:0] [SHIRINA_BANKI-1:0] ra,
input  logic [NUM_RD_PORTS-1:0]                    gnt,
output logic                    [SHIRINA_BANKI-1:0] ra_banki 
);

localparam LOG_NUM = $clog2(NUM_RD_PORTS);

logic [LOG_NUM-1:0] gnt_adr;


integer gnt_for;

always_comb begin
	gnt_adr = '0;
	for (gnt_for=0; gnt_for<NUM_RD_PORTS; gnt_for++) begin
		if (gnt[gnt_for] == 1'b1) gnt_adr = gnt_for; 
	end
end

assign ra_banki = ra[gnt_adr];

endmodule
