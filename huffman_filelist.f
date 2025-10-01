// Filelist para compilação do projeto UVM do decodificador Huffman
// Para uso com ferramentas Cadence

// Opções de compilação
-timescale 1ns/1ps
+define+UVM_NO_DEPRECATED
+define+UVM_OBJECT_MUST_HAVE_CONSTRUCTOR

// Diretórios de inclusão
+incdir+.
+incdir+${UVM_HOME}/src

// Arquivos UVM base (ajuste o caminho conforme necessário para seu ambiente Cadence)
-y ${UVM_HOME}/src
+libext+.sv

// Arquivos do projeto em ordem de compilação
./huffman_if.sv
./design.sv
./huffman_seq_item.sv
./huffman_sequencer.sv
./huffman_driver.sv
./huffman_monitor.sv
./huffman_agent.sv
./huffman_scoreboard.sv
./huffman_env.sv
./huffman_test.sv
./huffman_pkg.sv
./huffman_top.sv