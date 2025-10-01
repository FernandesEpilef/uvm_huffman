module huffman_top();
    import uvm_pkg::*;
    import huffman_pkg::*;

    // Sinais locais para conectar a interface e o DUT
    logic clk = 0;
    logic rst = 1; // Sinais de nível superior para o top-level

    // Gerar clock (50% duty cycle, 10ns período)
    initial begin
        forever #5 clk = ~clk; 
    end
    huffman_if intf(clk);

    // Instanciar o DUT
    huffman_decoder DUT (
        .clk(intf.clk),
        .rst(intf.rst), 
        .bit_in(intf.bit_in), 
        .symbol_out(intf.symbol_out),
        .valid_out(intf.valid_out)
    );

    // Configurar a interface virtual no UVM
    initial begin
        
        uvm_config_db#(virtual huffman_if.DRIVER)::set(null, "uvm_test_top.env.agent.driver", "vif", intf.DRIVER);
        
        uvm_config_db#(virtual huffman_if.DRIVER)::set(null, "uvm_test_top", "vif", intf.DRIVER);
        
        uvm_config_db#(virtual huffman_if.MONITOR)::set(null, "uvm_test_top.env.agent.monitor", "vif", intf.MONITOR);
    end

    // Iniciar o testbench UVM
    initial begin
        $display("Starting UVM Test...");
        run_test("huffman_test"); 
    end

endmodule 

