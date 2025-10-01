module huffman_decoder (
    input logic clk,
    input logic rst,
    input logic bit_in,
    output logic [4:0] symbol_out,
    output logic valid_out
);

    logic [7:0] shift_reg, next_shift;
    logic [3:0] bit_count, next_count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 0;
            bit_count <= 0;
        end else begin
            shift_reg <= next_shift;
            bit_count <= next_count;
        end
    end

    always_comb begin
        next_shift = {shift_reg[6:0], bit_in};
        next_count = bit_count + 1;
        valid_out = 0;
        symbol_out = 0;

        // Verifica códigos a cada quantidade possível de bits
        unique case (shift_reg[7 -: 7]) // 7 bits de MSB para LSB
            7'b0000000: if (bit_count == 1) begin symbol_out = 5'd1; valid_out = 1; next_count = 0; end
            7'b0000001: if (bit_count == 2) begin symbol_out = 5'd2; valid_out = 1; next_count = 0; end
            7'b0000010: if (bit_count == 3) begin symbol_out = 5'd3; valid_out = 1; next_count = 0; end
            7'b0000011: if (bit_count == 3) begin symbol_out = 5'd4; valid_out = 1; next_count = 0; end
            7'b0000100: if (bit_count == 3) begin symbol_out = 5'd5; valid_out = 1; next_count = 0; end
            7'b0000101: if (bit_count == 4) begin symbol_out = 5'd6; valid_out = 1; next_count = 0; end
            7'b0000110: if (bit_count == 4) begin symbol_out = 5'd7; valid_out = 1; next_count = 0; end
            7'b0000111: if (bit_count == 5) begin symbol_out = 5'd8; valid_out = 1; next_count = 0; end
            7'b0001000: if (bit_count == 6) begin symbol_out = 5'd9; valid_out = 1; next_count = 0; end
            7'b0001001: if (bit_count == 6) begin symbol_out = 5'd10; valid_out = 1; next_count = 0; end
            7'b0001010: if (bit_count == 6) begin symbol_out = 5'd11; valid_out = 1; next_count = 0; end
            7'b0001011: if (bit_count == 6) begin symbol_out = 5'd12; valid_out = 1; next_count = 0; end
            7'b0001100: if (bit_count == 6) begin symbol_out = 5'd13; valid_out = 1; next_count = 0; end
            7'b0001101: if (bit_count == 6) begin symbol_out = 5'd14; valid_out = 1; next_count = 0; end
            7'b0001110: if (bit_count == 6) begin symbol_out = 5'd15; valid_out = 1; next_count = 0; end
            7'b0001111: if (bit_count == 6) begin symbol_out = 5'd16; valid_out = 1; next_count = 0; end
            7'b0010000: if (bit_count == 6) begin symbol_out = 5'd17; valid_out = 1; next_count = 0; end
            7'b0010001: if (bit_count == 6) begin symbol_out = 5'd18; valid_out = 1; next_count = 0; end
            default: begin
                valid_out = 0;
            end
        endcase
    end

endmodule
