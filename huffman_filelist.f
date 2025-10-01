// Filelist para compilação do projeto UVM do decodificador Huffman
// Para uso com Xcelium da Cadence

// Opções de compilação
-timescale 1ns/1ps
-access +rwc
-uvmhome $UVMHOME
-uvm

// Diretórios de inclusão
-incdir .

// Arquivos do projeto em ordem de compilação
./huffman_if.sv
./huffman_pkg.sv
./design.sv
./huffman_top.sv