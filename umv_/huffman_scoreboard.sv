class huffman_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(huffman_scoreboard)
  
  // Porta de análise para receber transações
  uvm_analysis_imp #(huffman_seq_item, huffman_scoreboard) item_collected_export;
  
  // Estatísticas
  int num_passed = 0;
  int num_failed = 0;
  
  // Construtor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_export = new("item_collected_export", this);
  endfunction
  
  // Método para escrever transações
  virtual function void write(huffman_seq_item item);
    // Verificar se o símbolo de saída corresponde ao esperado
    if (item.expected_valid) begin
      if (item.expected_symbol >= 1 && item.expected_symbol <= 18) begin
        `uvm_info(get_type_name(), $sformatf("PASS: Símbolo válido %0d detectado", item.expected_symbol), UVM_LOW)
        num_passed++;
      end else begin
        `uvm_error(get_type_name(), $sformatf("FAIL: Símbolo inválido %0d detectado", item.expected_symbol))
        num_failed++;
      end
    end else begin
      `uvm_info(get_type_name(), "PASS: Nenhum símbolo válido detectado para entrada inválida", UVM_LOW)
      num_passed++;
    end
  endfunction
  
  // Relatório final
  virtual function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Scoreboard: %0d testes passaram, %0d testes falharam", 
                                         num_passed, num_failed), UVM_LOW)
  endfunction
  
endclass