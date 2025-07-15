module from_bank_to_core (
	input [2:0] gnt,
	input bank_1,
	input bank_2,
	input bank_3,
	output arb_to_proc
	//output arb_to_proc_2,
	//output arb_to_proc_3,
	
);
	
	logic [2:0] bank;
	assign bank = {bank_3, bank_2, bank_1};
	
	always_comb begin
		case(bank)
			3'b001 : arb_to_proc = gnt[0];
			3'b010 : arb_to_proc = gnt[1];
			3'b100 : arb_to_proc = gnt[2];
			default: arb_to_proc = 0;
		endcase 
	end
	
endmodule