class huffman_seq_item extends uvm_sequence_item;
  // Dados de entrada
  rand bit bit_in;
  
  // Dados de saída esperados
  rand bit [4:0] expected_symbol;
  rand bit expected_valid;
  
  // Campos para controle de sequência
  rand int num_bits;
  rand bit [7:0] bit_stream;
  
  // Restrições
  constraint c_num_bits { num_bits inside {1, 2, 3, 4, 5, 6}; }
  
  // Registrar objeto com factory UVM
  `uvm_object_utils_begin(huffman_seq_item)
    `uvm_field_int(bit_in, UVM_ALL_ON)
    `uvm_field_int(expected_symbol, UVM_ALL_ON)
    `uvm_field_int(expected_valid, UVM_ALL_ON)
    `uvm_field_int(num_bits, UVM_ALL_ON)
    `uvm_field_int(bit_stream, UVM_ALL_ON)
  `uvm_object_utils_end
  
  // Construtor
  function new(string name = "huffman_seq_item");
    super.new(name);
  endfunction
  
  // Método para converter para string
  virtual function string convert2string();
    return $sformatf("bit_in=%0b, expected_symbol=%0d, expected_valid=%0b, num_bits=%0d, bit_stream=%0b", 
                     bit_in, expected_symbol, expected_valid, num_bits, bit_stream);
  endfunction
  
endclass

class huffman_sequence extends uvm_sequence #(huffman_seq_item);
  `uvm_object_utils(huffman_sequence)
  
  // Construtor
  function new(string name = "huffman_sequence");
    super.new(name);
  endfunction
  
  // Método principal da sequência
  virtual task body();
    huffman_seq_item req;
    
    // Testar símbolo 1 (código: 0)
    req = huffman_seq_item::type_id::create("req");
    start_item(req);
    req.bit_stream = 8'b00000000;
    req.num_bits = 1;
    req.expected_symbol = 5'd1;
    req.expected_valid = 1'b1;
    finish_item(req);
    
    // Testar símbolo 2 (código: 10)
    req = huffman_seq_item::type_id::create("req");
    start_item(req);
    req.bit_stream = 8'b00000010;
    req.num_bits = 2;
    req.expected_symbol = 5'd2;
    req.expected_valid = 1'b1;
    finish_item(req);
    
    // Testar símbolo 3 (código: 100)
    req = huffman_seq_item::type_id::create("req");
    start_item(req);
    req.bit_stream = 8'b00000100;
    req.num_bits = 3;
    req.expected_symbol = 5'd3;
    req.expected_valid = 1'b1;
    finish_item(req);
    
    // Testar outros símbolos
    for (int i = 4; i <= 18; i++) begin
      req = huffman_seq_item::type_id::create("req");
      start_item(req);
      
      // Configurar bit_stream com base no símbolo
      case (i)
        4: begin req.bit_stream = 8'b00000011; req.num_bits = 3; end
        5: begin req.bit_stream = 8'b00000100; req.num_bits = 3; end
        6: begin req.bit_stream = 8'b00000101; req.num_bits = 4; end
        7: begin req.bit_stream = 8'b00000110; req.num_bits = 4; end
        8: begin req.bit_stream = 8'b00000111; req.num_bits = 5; end
        9: begin req.bit_stream = 8'b00001000; req.num_bits = 6; end
        10: begin req.bit_stream = 8'b00001001; req.num_bits = 6; end
        11: begin req.bit_stream = 8'b00001010; req.num_bits = 6; end
        12: begin req.bit_stream = 8'b00001011; req.num_bits = 6; end
        13: begin req.bit_stream = 8'b00001100; req.num_bits = 6; end
        14: begin req.bit_stream = 8'b00001101; req.num_bits = 6; end
        15: begin req.bit_stream = 8'b00001110; req.num_bits = 6; end
        16: begin req.bit_stream = 8'b00001111; req.num_bits = 6; end
        17: begin req.bit_stream = 8'b00010000; req.num_bits = 6; end
        18: begin req.bit_stream = 8'b00010001; req.num_bits = 6; end
      endcase
      
      req.expected_symbol = i;
      req.expected_valid = 1'b1;
      finish_item(req);
    end
    
    // Testar código inválido
    req = huffman_seq_item::type_id::create("req");
    start_item(req);
    req.bit_stream = 8'b11111111;
    req.num_bits = 3;
    req.expected_symbol = 5'd0;
    req.expected_valid = 1'b0;
    finish_item(req);
  endtask
  
endclass

class huffman_sequencer extends uvm_sequencer #(huffman_seq_item);
  `uvm_component_utils(huffman_sequencer)
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
endclass