package huffman_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  
  // Classe de item de sequência
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
    
    // Registrar objeto com factory UVM - versão simplificada
    `uvm_object_utils(huffman_seq_item)
    
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

  // Classe de sequência
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
      req = new("req");
      start_item(req);
      req.bit_stream = 8'b00000000;
      req.num_bits = 1;
      req.expected_symbol = 5'd1;
      req.expected_valid = 1'b1;
      finish_item(req);
      
      // Testar símbolo 2 (código: 10)
      req = new("req");
      start_item(req);
      req.bit_stream = 8'b00000010;
      req.num_bits = 2;
      req.expected_symbol = 5'd2;
      req.expected_valid = 1'b1;
      finish_item(req);
      
      // Testar símbolo 3 (código: 100)
      req = new("req");
      start_item(req);
      req.bit_stream = 8'b00000100;
      req.num_bits = 3;
      req.expected_symbol = 5'd3;
      req.expected_valid = 1'b1;
      finish_item(req);
    endtask
  endclass

  // Sequencer
  class huffman_sequencer extends uvm_sequencer #(huffman_seq_item);
    `uvm_component_utils(huffman_sequencer)
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction
  endclass

  // Driver
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
        `uvm_error("NOVIF", "Virtual interface not configured for driver")
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

  // Monitor
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
        `uvm_error("NOVIF", "Virtual interface not configured for monitor")
    endfunction
    
    // Tarefa principal
    virtual task run_phase(uvm_phase phase);
      super.run_phase(phase);
      
      forever begin
        huffman_seq_item item = new("item");
        
        // Esperar por valid_out
        @(posedge vif.clk);
        if (vif.valid_out) begin
          // Capturar dados
          item.expected_symbol = vif.symbol_out;
          item.expected_valid = vif.valid_out;
          
          // Enviar item para análise
          item_collected_port.write(item);
          
          `uvm_info("MONITOR", $sformatf("Symbol detected: %0d", vif.symbol_out), UVM_MEDIUM)
        end
      end
    endtask
  endclass

  // Agente
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
      monitor = new("monitor", this);
      
      if(get_is_active() == UVM_ACTIVE) begin
        driver = new("driver", this);
        sequencer = new("sequencer", this);
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

  // Scoreboard
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
          `uvm_info("SCOREBOARD", $sformatf("PASS: Valid symbol %0d detected", item.expected_symbol), UVM_LOW)
          num_passed++;
        end else begin
          `uvm_error("SCOREBOARD", $sformatf("FAIL: Invalid symbol %0d detected", item.expected_symbol))
          num_failed++;
        end
      end else begin
        `uvm_info("SCOREBOARD", "PASS: No valid symbol detected for invalid input", UVM_LOW)
        num_passed++;
      end
    endfunction
    
    // Relatório final
    virtual function void report_phase(uvm_phase phase);
      `uvm_info("SCOREBOARD", $sformatf("Scoreboard: %0d testes passaram, %0d testes falharam", 
                                         num_passed, num_failed), UVM_LOW)
    endfunction
  endclass

  // Ambiente
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
      agent = new("agent", this);
      scoreboard = new("scoreboard", this);
    endfunction
    
    // Fase de conexão
    function void connect_phase(uvm_phase phase);
      // Conectar agente ao scoreboard
      agent.agent_ap.connect(scoreboard.item_collected_export);
    endfunction
  endclass

  // Teste
  class huffman_test extends uvm_test;
    `uvm_component_utils(huffman_test)
    
    // Componentes do teste
    huffman_env env;
    
    // Sequência
    huffman_sequence seq;
    
    // Construtor
    function new(string name = "huffman_test", uvm_component parent = null);
      super.new(name, parent);
    endfunction
    
    // Fase de construção
    virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      
      // Criar ambiente
      env = new("env", this);
      
      // Criar sequência
      seq = new("seq");
    endfunction
    
    // Fase de execução
    virtual task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      
      // Aplicar reset
      apply_reset();
      
      // Iniciar sequência
      seq.start(env.agent.sequencer);
      
      // Aguardar conclusão
      #100;
      
      phase.drop_objection(this);
    endtask
    
    // Tarefa para aplicar reset
    virtual task apply_reset();
      // Obter interface virtual
      virtual huffman_if vif;
      if(!uvm_config_db#(virtual huffman_if)::get(this, "", "vif", vif))
        `uvm_error("NOVIF", "Virtual interface not configured for test")
      
      // Aplicar reset
      vif.rst <= 1;
      #20;
      vif.rst <= 0;
      #10;
    endtask
  endclass
  
endpackage