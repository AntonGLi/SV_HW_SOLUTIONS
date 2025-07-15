module raspredelyator_ot_addr_k_bank (
	input [31:0] addr,
	output bank_0,
	output bank_1,
	output bank_2,
	
	input NER,
	output [2:0] req
);

always_comb begin

		bank_0 = 1'd0;
		bank_1 = 1'd0;
		bank_2 = 1'd0;
		req = '0;
		
	if (addr < 128) begin 
		bank_0 = 1'd1;
		bank_1 = 1'd0;
		bank_2 = 1'd0;
		if (NER) req[0] = 1'b1;
	end
	
	if ((addr >= 128) && (addr < 256)) begin
		bank_0 = 1'd0;
		bank_1 = 1'd1;
		bank_2 = 1'd0;
		if (NER) req[1] = 1'b1;
	end
	
	if (addr >= 256) begin 
		bank_0 = 1'd0;
		bank_1 = 1'd0;
		bank_2 = 1'd1;
		if (NER) req[2] = 1'b1;
	end

end
endmodule