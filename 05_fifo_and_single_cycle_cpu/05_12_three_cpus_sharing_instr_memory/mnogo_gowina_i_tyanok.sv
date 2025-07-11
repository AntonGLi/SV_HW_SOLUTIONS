module mnogo_gowina_i_tyanok (
	input clk,
	input rst,
	
	input logic [31:0] regData,
	input logic [31:0] regAddr,
	input logic [31:0] PC [2:0] 

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

round_robin_arbiter_8 KAROL_TYALETA
(
    .clk(clk),
    .rst(rst),
    .req(req),
    .gnt(NADO_RAB)
);

srat_cpu tualet1
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


srat_cpu tualet2
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


srat_cpu tualet3
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

logic [ADDR_W - 1:0] pc_chosen;
logic [31:0]         govina;

localparam size = 64;
localparam ADDR_W = $clog2(SIZE);

instruction_rom tyan
#(
.SIZE(size)
)
(
    .a(pc_chosen),
    .rd(govina)
);

assign pc_chosen = ()











endmodule