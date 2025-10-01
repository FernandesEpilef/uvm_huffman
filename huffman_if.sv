interface huffman_if(input logic clk, input logic rst);
  // Sinais de interface
  logic bit_in;
  logic [4:0] symbol_out;
  logic valid_out;
  
  // Propriedades para asserções
  property valid_symbol_range;
    @(posedge clk) valid_out |-> (symbol_out >= 1 && symbol_out <= 18);
  endproperty
  
  // Asserções
  assert property (valid_symbol_range)
    else $error("Símbolo fora do intervalo válido: %d", symbol_out);
  
endinterface