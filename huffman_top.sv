`include "uvm_macros.svh"
`include "huffman_if.sv"
`include "huffman_pkg.sv"

module huffman_top;
  import uvm_pkg::*;
  import huffman_pkg::*;
  
  // Sinais de clock e reset
  logic clk;
  logic rst;
  
  // Geração de clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  // Interface
  huffman_if intf(clk, rst);
  
  // Instância do DUT
  huffman_decoder dut (
    .clk(intf.clk),
    .rst(intf.rst),
    .bit_in(intf.bit_in),
    .symbol_out(intf.symbol_out),
    .valid_out(intf.valid_out)
  );
  
  // Iniciar teste
  initial begin
    // Configurar interface
    uvm_config_db#(virtual huffman_if)::set(null, "*", "vif", intf);
    
    // Iniciar teste
    run_test("huffman_test");
  end
  
  // Dump de formas de onda
  initial begin
    $dumpfile("huffman_uvm.vcd");
    $dumpvars(0, huffman_top);
  end
  
endmodule