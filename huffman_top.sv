module huffman_top();

    // ADIÇÃO CRÍTICA 1: Importar o pacote UVM para usar uvm_config_db
    import uvm_pkg::*;
    // ADIÇÃO CRÍTICA 2: Importar o pacote de verificação para que run_test encontre a classe huffman_test
    import huffman_pkg::*;

    // Sinais locais para conectar a interface e o DUT
    logic clk = 0;
    logic rst = 1; // Sinais de nível superior para o top-level

    // Gerar clock (50% duty cycle, 10ns período)
    initial begin
        forever #5 clk = ~clk; 
    end

    // Instanciar a Interface (apenas 'clk' no cabeçalho)
    huffman_if intf(clk);

    // Conectar o sinal 'rst' local ao 'rst' DENTRO da interface
    // Este 'assign' é usado porque o UVM Test (que faz o reset) 
    // está injetando o valor em intf.rst, que é um 'logic' no corpo da interface.
    // Como o UVM Test já dirige 'intf.rst' diretamente, esta linha será ignorada
    // ou pode ser redundante, mas a deixaremos para conectar o DUT.
    // assign intf.rst = rst; // Removendo esta linha para permitir que o UVM controle totalmente 'intf.rst'

    // Instanciar o DUT (Unit Under Test)
    huffman_decoder DUT (
        .clk(intf.clk),
        .rst(intf.rst), 
        .bit_in(intf.bit_in), 
        .symbol_out(intf.symbol_out),
        .valid_out(intf.valid_out)
    );

    // Configurar a interface virtual no UVM
    initial begin
        // CORREÇÃO: Passar a interface usando o modport correto para cada componente.
        
        // Configuração para DRIVER e TEST (que usam o modport DRIVER)
        // Usamos uvm_test_top (o nome do módulo de teste de nível superior)
        uvm_config_db#(virtual huffman_if.DRIVER)::set(null, "uvm_test_top.env.agent.driver", "vif", intf.DRIVER);
        
        // CORREÇÃO DE PATH APLICADA: Configurar diretamente o uvm_test_top
        uvm_config_db#(virtual huffman_if.DRIVER)::set(null, "uvm_test_top", "vif", intf.DRIVER);
        
        // Configuração para MONITOR (que usa o modport MONITOR)
        uvm_config_db#(virtual huffman_if.MONITOR)::set(null, "uvm_test_top.env.agent.monitor", "vif", intf.MONITOR);
    end

    // Iniciar o testbench UVM
    initial begin
        $display("Starting UVM Test...");
        run_test("huffman_test"); 
    end

endmodule 

