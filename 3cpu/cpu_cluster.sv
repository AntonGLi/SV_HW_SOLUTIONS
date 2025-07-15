//
//  schoolRISCV - small RISC-V CPU
//
//  Originally based on Sarah L. Harris MIPS CPU
//  & schoolMIPS project.
//
//  Copyright (c) 2017-2020 Stanislav Zhelnio & Aleksandr Romanov.
//
//  Modified in 2024 by Yuri Panchul & Mike Kuskov
//  for systemverilog-homework project.
//

module cpu_cluster
#(
    parameter nCPUs = 8
)
(
    input                        clk,      // clock
    input                        rst,      // reset

    input   [nCPUs - 1:0][31:0]  rstPC,    // program counter set on reset
    input   [nCPUs - 1:0][ 4:0]  regAddr,  // debug access reg address
    output  [nCPUs - 1:0][31:0]  regData   // debug access reg data
);

localparam NUM_RD_PORTS = nCPUs;
localparam NUM_BANKS    = 2;
localparam SIZE_BANKI   = 32;

localparam SHIRINA_BANKI =      $clog2(SIZE_BANKI);
localparam SHIRINA_VSEH_BANOK = $clog2(SIZE_BANKI*NUM_BANKS);

logic [NUM_RD_PORTS -1:0] [SHIRINA_VSEH_BANOK -1:0] ra;
logic [NUM_RD_PORTS -1:0] [                   31:0] rd;

logic [NUM_RD_PORTS -1:0]                           gnt_cpu;
logic [NUM_RD_PORTS -1:0]                           req_cpu;

genvar cpu_gen;

generate
	for (cpu_gen=0; cpu_gen<NUM_RD_PORTS; cpu_gen++) begin : TYANKI

		
		srat_cpu TYANKA
(
		.clk(clk),      // clock
		.rst(rst),      // reset

		.rstPC(rstPC[cpu_gen]),      // program counter set on reset

		.imAddr(ra[cpu_gen]),   // instruction memory address
		.imData(rd[cpu_gen]),   // instruction memory data

		.NADO_RABOTAT(gnt_cpu[cpu_gen]),  // instruction memory data valid
		.NE_RABOTAT(req_cpu[cpu_gen]),

		.regAddr(regAddr[cpu_gen]),    // debug access reg address
		.regData(regData[cpu_gen])     // debug access reg data
);
	end
endgenerate

meme_v_bankah
#(
	.NUM_BANKS(NUM_BANKS),
	.SIZE_BANKI(SIZE_BANKI),

	.NUM_RD_PORTS(NUM_RD_PORTS) // <8 restriction from arbiter
) tualet (
	.clk(clk),
	.rst(rst),

	.ra(ra),
	.req_cpu(req_cpu),
	.gnt_cpu(gnt_cpu),
	.rd(rd)
);

endmodule
