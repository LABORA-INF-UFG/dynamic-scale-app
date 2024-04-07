while true; do
    while IFS= read -r line; do
        dia=$(date '+%Y-%m-%d')
        hora=$(date '+%H:%M:%S')
        milissegundos=$(date '+%N' | cut -c1-3)
        timestamp="$dia;$hora;$milissegundos"
        
        # Separando os campos do resultado do comando kubectl get hpa
        IFS=' ' read -r -a fields <<< "$line"
        
        # Montando o resultado, incluindo todos os campos
        resultado=""
        for field in "${fields[@]}"; do
            resultado="$resultado;$field"
        done

        echo "$timestamp;$resultado"
    done < <(kubectl get hpa keda-hpa-python-rabbitmq-scaledobject --watch)
done > logs/escalonamento.csv

