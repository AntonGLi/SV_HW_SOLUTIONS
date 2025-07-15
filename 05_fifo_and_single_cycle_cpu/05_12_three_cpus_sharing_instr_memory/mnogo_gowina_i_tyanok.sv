module mnogo_gowina_i_tyanok (
	input clk,
	input rst,
	
	input logic [2:0] [31:0] regData,
	input logic [2:0] [31:0] regAddr,
	input logic [31:0] PC [0:2] 

);


logic [31:0] imAddr_1;
logic [31:0] regData_1;
logic [31:0] regAddr_1;
logic [31:0] imData_1;

logic [31:0] imAddr_2;
logic [31:0] regData_2;
logic [31:0] regAddr_2;
logic [31:0] imData_2;

logic [31:0] imAddr_3;
logic [31:0] regData_3;
logic [31:0] regAddr_3;
logic [31:0] imData_3;

logic NeR_1;
logic NeR_2;
logic NeR_3;

wire [7:0] req;
assign req = {5'd0, NeR_3, NeR_2, NeR_1};

logic [2:0] NADO_RAB;

logic [2:0] NADO_RAB_1;
logic [2:0] NADO_RAB_2;
logic [2:0] NADO_RAB_3;

logic tuk_tuk_ot_1_v_0;
logic tuk_tuk_ot_1_v_1;
logic tuk_tuk_ot_1_v_2;

logic tuk_tuk_ot_2_v_0;
logic tuk_tuk_ot_2_v_1;
logic tuk_tuk_ot_2_v_2;

logic tuk_tuk_ot_3_v_0;
logic tuk_tuk_ot_3_v_1;
logic tuk_tuk_ot_3_v_2;

logic [2:0] in_arb_1;
logic [2:0] in_arb_2;
logic [2:0] in_arb_3;

logic [2:0] req_ot_1;
logic [2:0] req_ot_2;
logic [2:0] req_ot_3;

assign in_arb_1 = {tuk_tuk_ot_1_v_0 & req_ot_1[0], tuk_tuk_ot_2_v_0 & req_ot_2[0], tuk_tuk_ot_3_v_0 & req_ot_3[0]};
assign in_arb_2 = {tuk_tuk_ot_1_v_1 & req_ot_1[1], tuk_tuk_ot_2_v_1 & req_ot_2[1], tuk_tuk_ot_3_v_1 & req_ot_3[1]};
assign in_arb_3 = {tuk_tuk_ot_1_v_2 & req_ot_1[2], tuk_tuk_ot_2_v_2 & req_ot_2[2], tuk_tuk_ot_3_v_2 & req_ot_3[2]};


round_robin_arbiter_8 DVER_TYALETA_1
(
    .clk(clk),
    .rst(rst),
    .req(in_arb_1),
    .gnt(NADO_RAB_1)
);

from_bank_to_core DVER_CHECKER_1
(
	.gnt({NADO_RAB_3[0], NADO_RAB_2[0], NADO_RAB_1[0]}),
	.bank_1(tuk_tuk_ot_1_v_0),
	.bank_2(tuk_tuk_ot_1_v_1),
	.bank_3(tuk_tuk_ot_1_v_2),
	.arb_to_proc(NADO_RAB[0])
);

round_robin_arbiter_8 DVER_TYALETA_2
(
    .clk(clk),
    .rst(rst),
    .req(in_arb_2),
    .gnt(NADO_RAB_2)
);

from_bank_to_core DVER_CHECKER_2
(
	.gnt({NADO_RAB_3[1], NADO_RAB_2[1], NADO_RAB_1[1]}),
	.bank_1(tuk_tuk_ot_2_v_0),
	.bank_2(tuk_tuk_ot_2_v_1),
	.bank_3(tuk_tuk_ot_2_v_2),
	.arb_to_proc(NADO_RAB[1])
);

round_robin_arbiter_8 DVER_TYALETA_3
(
    .clk(clk),
    .rst(rst),
    .req(in_arb_3),
    .gnt(NADO_RAB_3)
);

from_bank_to_core DVER_CHECKER_3
(
	.gnt({NADO_RAB_3[2], NADO_RAB_2[2], NADO_RAB_1[2]}),
	.bank_1(tuk_tuk_ot_3_v_0),
	.bank_2(tuk_tuk_ot_3_v_1),
	.bank_3(tuk_tuk_ot_3_v_2),
	.arb_to_proc(NADO_RAB[2])
);

srat_cpu tyanka_1
(
    .clk(clk),      // clock
    .rst(rst),      // reset

    .imAddr(imAddr_1),   // instruction memory address
    .imData(imData_1),   // instruction memory data

    .regAddr(regAddr_1),  // debug access reg address
    .regData(regData_1) ,	 // debug access reg data
	 .NE_RABOTAT(NeR_1),
	 .NADO_RABOTAT(NADO_RAB[0])
);


srat_cpu tyanka_2
(
    .clk(clk),      // clock
    .rst(rst),      // reset

    .imAddr(imAddr_2),   // instruction memory address
    .imData(imData_2),   // instruction memory data

    .regAddr(regAddr_2),  // debug access reg address
    .regData(regData_2),
	  .NE_RABOTAT(NeR_2),
	  .NADO_RABOTAT (NADO_RAB[1])// debug access reg data
);


srat_cpu tyanka_3
(
    .clk(clk),      // clock
    .rst(rst),      // reset

    .imAddr(imAddr_3),   // instruction memory address
    .imData(imData_3),   // instruction memory data

    .regAddr(regAddr_3),  // debug access reg address
    .regData(regData_3),   // debug access reg data
	 .NE_RABOTAT(NeR_3),
	 .NADO_RABOTAT(NADO_RAB[2])
);

logic [ADDR_W - 1:0] pc_chosen_1;
logic [31:0]         govina_1;

//tut herb
assign pc_chosen = NADO_RAB_1 ;

logic [ADDR_W - 1:0] pc_chosen_2;
logic [31:0]         govina_2;


logic [ADDR_W - 1:0] pc_chosen_3;
logic [31:0]         govina_3;


localparam size = 64;
localparam ADDR_W = $clog2(size);

instruction_rom 
#(
.SIZE(size)
) tyalet_1 (
    .a(pc_chosen_1),
    .rd(govina_1)
);

instruction_rom
#(
.SIZE(size)
) tyalet_2 (
    .a(pc_chosen_2),
    .rd(govina_2)
);


instruction_rom
#(
.SIZE(size)
) tyalet_3 (
    .a(pc_chosen_3),
    .rd(govina_3)
);

raspredelyator_ot_addr_k_bank sovet_1_tyanke (
	.addr(imAddr_1),
	.bank_0(tuk_tuk_ot_1_v_0),
	.bank_1(tuk_tuk_ot_1_v_1),
	.bank_2(tuk_tuk_ot_1_v_2),
	.NER(NeR_1),
	.req(req_ot_1)
);

raspredelyator_ot_addr_k_bank sovet_2_tyanke (
	.addr(imAddr_2),
	.bank_0(tuk_tuk_ot_2_v_0),
	.bank_1(tuk_tuk_ot_2_v_1),
	.bank_2(tuk_tuk_ot_2_v_2),
	.NER(NeR_2),
	.req(req_ot_2)
);

raspredelyator_ot_addr_k_bank sovet_3_tyanke (
	.addr(imAddr_3),
	.bank_0(tuk_tuk_ot_3_v_0),
	.bank_1(tuk_tuk_ot_3_v_1),
	.bank_2(tuk_tuk_ot_3_v_2),
	.NER(NeR_3),
	.req(req_ot_3)
);











endmodule