interface huffman_if(input logic clk);
    // Sinais de controle
    // Movido para o corpo como 'logic' para ser dirigível pelo testbench
    logic rst;      
    logic bit_in;

    // Sinais de saída (do DUT)
    logic [4:0] symbol_out;
    logic valid_out;
    
    //-----------------------------------------------
    // MODPORTS UVM
    // Definem a direção dos sinais para cada componente UVM
    //-----------------------------------------------
    modport DRIVER (
        output rst,         // O Driver/Testbench dirige o reset
        output bit_in,      // O Driver dirige o bit de entrada
        input clk           // O Driver lê o clock
    );

    modport MONITOR (
        input clk,          // O Monitor lê o clock
        input symbol_out,   // O Monitor lê a saída
        input valid_out     // O Monitor lê o sinal de validação
    );

    //-----------------------------------------------
    // PROPRIEDADES DE ASSERÇÃO
    //-----------------------------------------------
    
    // Propriedade para asserções: Símbolo válido deve estar entre 1 e 18
    property valid_symbol_range;
        @(posedge clk) valid_out |-> (symbol_out >= 1 && symbol_out <= 18);
    endproperty
    
    // Asserção
    assert property (valid_symbol_range)
        else $error("Símbolo fora do intervalo válido: %0d", symbol_out);
    
endinterface

