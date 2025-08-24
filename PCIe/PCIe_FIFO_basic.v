`timescale 1ns / 1ps
`default_nettype none

module tlp_fifo_simple #(
    parameter DEPTH = 16,                  // number of FIFO entries
    parameter ADDR_WIDTH = 4,              // log2(DEPTH) (for DEPTH=16 => 4)
    parameter TLP_DATA_WIDTH = 128,        // payload data width (bits)
    parameter TLP_HDR_WIDTH  = 128         // header width (bits), we choose 128 for simplicity
) (
    input  wire                      clk,
    input  wire                      rst,

    // input side (producer)
    input  wire [TLP_DATA_WIDTH-1:0] in_data,
    input  wire [TLP_HDR_WIDTH-1:0]  in_hdr,
    input  wire                     in_valid,
    input  wire                     in_sop,
    input  wire                     in_eop,
    output wire                     in_ready,

    // output side (consumer)
    output wire [TLP_DATA_WIDTH-1:0] out_data,
    output wire [TLP_HDR_WIDTH-1:0]  out_hdr,
    output wire                     out_valid,
    input  wire                     out_ready
);

    // circular pointers
    reg [ADDR_WIDTH:0] wr_ptr = 0; // extra MSB for full detection (gray/dual-ported style)
    reg [ADDR_WIDTH:0] rd_ptr = 0;

    // storage arrays (simple registers)
    reg [TLP_DATA_WIDTH-1:0] mem_data [0:DEPTH-1];
    reg [TLP_HDR_WIDTH-1:0]  mem_hdr  [0:DEPTH-1];
    reg                     mem_valid[0:DEPTH-1]; // stores whether entry is valid (optional)

    // compute simple flags
    wire full  = ( (wr_ptr[ADDR_WIDTH] ^ rd_ptr[ADDR_WIDTH]) &&
                   (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]) );
    wire empty = (wr_ptr == rd_ptr);

    // probe ready/valid handshake
    assign in_ready  = !full;
    assign out_valid = !empty;

    // output mux
    assign out_data = mem_data[rd_ptr[ADDR_WIDTH-1:0]];
    assign out_hdr  = mem_hdr[rd_ptr[ADDR_WIDTH-1:0]];

    // write logic
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
            // clear memory valid bits for clarity
            integer i;
            for (i = 0; i < DEPTH; i = i + 1) mem_valid[i] <= 1'b0;
        end else begin
            if (in_valid && in_ready) begin
                mem_data[wr_ptr[ADDR_WIDTH-1:0]] <= in_data;
                mem_hdr[wr_ptr[ADDR_WIDTH-1:0]]  <= in_hdr;
                mem_valid[wr_ptr[ADDR_WIDTH-1:0]] <= 1'b1;
                wr_ptr <= wr_ptr + 1;
            end
        end
    end

    // read logic
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr <= 0;
        end else begin
            if (out_valid && out_ready) begin
                // consumer accepted data -> advance read pointer
                mem_valid[rd_ptr[ADDR_WIDTH-1:0]] <= 1'b0;
                rd_ptr <= rd_ptr + 1;
            end
        end
    end

endmodule