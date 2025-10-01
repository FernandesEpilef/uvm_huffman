class huffman_env extends uvm_env;
  `uvm_component_utils(huffman_env)
  
  // Componentes do ambiente
  huffman_agent    agent;
  huffman_scoreboard scoreboard;
  
  // Construtor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Fase de construção
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Criar componentes
    agent = huffman_agent::type_id::create("agent", this);
    scoreboard = huffman_scoreboard::type_id::create("scoreboard", this);
  endfunction
  
  // Fase de conexão
  function void connect_phase(uvm_phase phase);
    // Conectar agente ao scoreboard
    agent.agent_ap.connect(scoreboard.item_collected_export);
  endfunction
  
endclass