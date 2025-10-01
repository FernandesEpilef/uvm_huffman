# Script TCL para compilação e simulação do projeto UVM do decodificador Huffman
# Para uso com ferramentas Cadence

# Configuração de diretórios
set PROJ_DIR [pwd]
set DESIGN_DIR $PROJ_DIR

# Limpar resultados anteriores
if {[file exists work]} {
    file delete -force work
}
vlib work

# Compilar todos os arquivos usando o filelist
vlog -f huffman_filelist.f

# Iniciar simulação
vsim -novopt huffman_top

# Configurar ondas
if {[file exists wave.do]} {
    do wave.do
} else {
    add wave -r /*
}

# Executar simulação
run -all

# Exibir resultados
puts "\n\n==== Simulação concluída ===="
puts "Verifique os resultados no scoreboard UVM"