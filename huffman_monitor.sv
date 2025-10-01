class huffman_monitor extends uvm_monitor;
  `uvm_component_utils(huffman_monitor)
  
  // Interface virtual
  virtual huffman_if vif;
  
  // Análise de porta para enviar transações
  uvm_analysis_port #(huffman_seq_item) item_collected_port;
  
  // Construtor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction
  
  // Fase de construção
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual huffman_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface não foi configurada para o monitor")
  endfunction
  
  // Tarefa principal
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      huffman_seq_item item = huffman_seq_item::type_id::create("item");
      
      // Esperar por valid_out
      @(posedge vif.clk);
      if (vif.valid_out) begin
        // Capturar dados
        item.expected_symbol = vif.symbol_out;
        item.expected_valid = vif.valid_out;
        
        // Enviar item para análise
        item_collected_port.write(item);
        
        `uvm_info(get_type_name(), $sformatf("Símbolo detectado: %0d", vif.symbol_out), UVM_MEDIUM)
      end
    end
  endtask
  
endclass