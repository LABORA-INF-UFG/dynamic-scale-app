#!/bin/bash

# Diretório e arquivo de log
SOBRECARGA_LOG_DIR="/root/testes/keda-python-rabbit/logs"
SOBRECARGA_LOG_FILE="$SOBRECARGA_LOG_DIR/evento_sobrecarga.csv"

# Cria o diretório de log se não existir
mkdir -p "$SOBRECARGA_LOG_DIR"

# Cabeçalho do CSV
echo "Data;HoraMinutoSegundo;Milissegundos;Evento;TotalMensagensEnviadas" > "$SOBRECARGA_LOG_FILE"

# Função para gerar um número aleatório entre dois valores
function gerar_numero_aleatorio {
    echo $((RANDOM % ($2 - $1 + 1) + $1))
}

# Função para registrar no log
function registrar_log {
    timestamp=$(date "+%Y-%m-%d %H:%M:%S.%3N")  # Adicionando milissegundos
    data=$(date -d "$timestamp" "+%Y-%m-%d")
    hora_minuto_segundo=$(date -d "$timestamp" "+%H:%M:%S")
    milissegundos=$(date -d "$timestamp" "+%3N")
    echo "$data;$hora_minuto_segundo;$milissegundos;$1" >> "$SOBRECARGA_LOG_FILE"
}

# Inicialização de uma variável de controle para o loop
contador=1

numero_de_mensagens=$(gerar_numero_aleatorio 9500 10500)

echo "_____"
echo "Sobrecarga: Evento $contador"
echo "Total de mensagens enviadas:" 
echo "$numero_de_mensagens"
echo "$(date '+%Y-%m-%d %H:%M:%S')"
registrar_log "Evento $contador; $numero_de_mensagens"
python3 -m app.rabbit_publisher "$numero_de_mensagens"

# Incrementa o contador
((contador++))

# Loop para executar os demais eventos de sobrecarga indefinidamente
while true; do
    # Gera um número aleatório para o intervalo entre 7200 e 10800 segundos
    intervalo=$(gerar_numero_aleatorio 7200 10800)
    echo "Aguardando $intervalo segundos antes do Evento $contador"

    # Aguarda o intervalo antes de executar o próximo evento de sobrecarga
    sleep $intervalo

    # Número de mensagens para o evento atual
    numero_de_mensagens=$(gerar_numero_aleatorio 9500 10500)

    echo "_____"
    echo "Sobrecarga: Evento $contador"
    echo "Total de mensagens enviadas:"
    echo "$numero_de_mensagens"
    echo "$(date '+%Y-%m-%d %H:%M:%S')"
    registrar_log "Evento $contador; $numero_de_mensagens"
    python3 -m app.rabbit_publisher "$numero_de_mensagens"

    # Incrementa o contador
    ((contador++))
done

