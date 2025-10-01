class huffman_agent extends uvm_agent;
  `uvm_component_utils(huffman_agent)
  
  // Componentes do agente
  huffman_driver    driver;
  huffman_sequencer sequencer;
  huffman_monitor   monitor;
  
  // Porta de análise
  uvm_analysis_port #(huffman_seq_item) agent_ap;
  
  // Construtor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Fase de construção
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Criar porta de análise
    agent_ap = new("agent_ap", this);
    
    // Criar componentes
    monitor = huffman_monitor::type_id::create("monitor", this);
    
    if(get_is_active() == UVM_ACTIVE) begin
      driver = huffman_driver::type_id::create("driver", this);
      sequencer = huffman_sequencer::type_id::create("sequencer", this);
    end
  endfunction
  
  // Fase de conexão
  function void connect_phase(uvm_phase phase);
    if(get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
    
    // Conectar monitor à porta de análise do agente
    monitor.item_collected_port.connect(agent_ap);
  endfunction
  
endclass