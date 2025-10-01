`timescale 1ns/1ns

module tb_huffman_decoder;

    logic clk = 0;
    logic rst = 1;
    logic bit_in;
    logic [4:0] symbol_out;
    logic valid_out;

    huffman_decoder uut (
        .clk(clk),
        .rst(rst),
        .bit_in(bit_in),
        .symbol_out(symbol_out),
        .valid_out(valid_out)
    );

    // Clock
    always #5 clk = ~clk;

    // Dump waves
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_huffman_decoder);
    end

    // Estímulo
    initial begin
        #10 rst = 0;

        // Exemplo: enviar código de 1 bit '0' → símbolo 1
        send_bits(1'b0);   #20;

        // Exemplo: código de 2 bits '10' → símbolo 2
        send_bits(2'b10);  #20;

        // Exemplo: código de 3 bits '100' → símbolo 3
        send_bits(3'b100); #20;

        // Código inválido: só '111' (não existe)
        send_bits(3'b111); #20;

        #100 $finish;
    end

    task send_bits(input [7:0] bits);
        integer i;
        for (i = 7; i >= 0; i = i - 1) begin
            bit_in = bits[i];
            #10;
        end
    endtask

endmodule
