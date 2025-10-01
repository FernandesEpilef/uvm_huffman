`include "uvm_macros.svh"
package huffman_pkg;
  import uvm_pkg::*;
  
  // Declarações antecipadas
  typedef class huffman_seq_item;
  typedef class huffman_sequencer;
  typedef class huffman_driver;
  typedef class huffman_monitor;
  typedef class huffman_agent;
  typedef class huffman_scoreboard;
  typedef class huffman_env;
  typedef class huffman_test;
  
  // Incluir arquivos de componentes
  `include "huffman_seq_item.sv"
  `include "huffman_sequencer.sv"
  `include "huffman_driver.sv"
  `include "huffman_monitor.sv"
  `include "huffman_agent.sv"
  `include "huffman_scoreboard.sv"
  `include "huffman_env.sv"
  `include "huffman_test.sv"
  
endpackage