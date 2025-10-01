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
    env = huffman_env::type_id::create("env", this);
    
    // Criar sequência
    seq = huffman_sequence::type_id::create("seq");
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
    if (!uvm_config_db#(virtual huffman_if)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface não foi configurada para o teste")
    
    // Aplicar reset
    vif.rst <= 1;
    #20;
    vif.rst <= 0;
    #10;
  endtask
  
endclass