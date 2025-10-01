class huffman_driver extends uvm_driver #(huffman_seq_item);
  `uvm_component_utils(huffman_driver)
  
  // Interface virtual
  virtual huffman_if vif;
  
  // Construtor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Fase de construção
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual huffman_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface não foi configurada para o driver")
  endfunction
  
  // Tarefa principal
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    // Inicializar sinais
    vif.bit_in <= 0;
    
    forever begin
      huffman_seq_item req;
      
      // Esperar pelo item de sequência
      seq_item_port.get_next_item(req);
      
      // Enviar bits para o DUT
      drive_bits(req);
      
      // Sinalizar conclusão
      seq_item_port.item_done();
    end
  endtask
  
  // Tarefa para enviar bits
  virtual task drive_bits(huffman_seq_item req);
    // Enviar bits um por um, do MSB para o LSB
    for (int i = req.num_bits-1; i >= 0; i--) begin
      @(posedge vif.clk);
      vif.bit_in <= req.bit_stream[i];
    end
    
    // Esperar um ciclo adicional para processamento
    @(posedge vif.clk);
  endtask
  
endclass