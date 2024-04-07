#!/bin/bash

# Diretório para o arquivo de log
LOG_DIR="/root/testes/keda-python-rabbit/logs"
LOG_FILE="$LOG_DIR/evento_padrao.csv"

# Verificar se o diretório de log existe, se não, criar
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
fi

# Cabeçalho do CSV
echo "Data;HoraMinutoSegundo;Milissegundos;MensagensEnviadas;ComandoExecutado" > "$LOG_FILE"

# Loop para executar o comando a cada 10 segundos durante 24 horas
for (( i=0; i<8640; i++ )); do
    # Gerar um número aleatório de mensagens
    numero_de_mensagens=$((100 + RANDOM % 250))  # Números aleatórios entre 100 e 350 (ajuste conforme necessário)

    # Construir o comando com o número de mensagens gerado aleatoriamente
    comando="python3 -m app.rabbit_publisher $numero_de_mensagens"

    # Registrar a data e hora da execução no log
    timestamp=$(date "+%Y-%m-%d %H:%M:%S.%3N")  # Adicionando milissegundos
    data=$(date -d "$timestamp" "+%Y-%m-%d")
    hora_minuto_segundo=$(date -d "$timestamp" "+%H:%M:%S")
    milissegundos=$(date -d "$timestamp" "+%3N")
    
    # Adicionar linha ao arquivo CSV
    echo "$data;$hora_minuto_segundo;$milissegundos;$numero_de_mensagens;$comando" >> "$LOG_FILE"

    # Exibir informações na tela
    echo "____"
    echo "O total de mensagens enviadas nos últimos 10 segundos:"
    echo "$numero_de_mensagens"
    echo "$timestamp - Executando: $comando"

    # Executar o comando
    $comando

    # Aguardar 10 segundos antes da próxima execução
    sleep 10  # 10 segundos
done

