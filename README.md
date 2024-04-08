# DynamicScaleApp
Repositório de desenvolvimento do artigo "Escalonamento Dinâmico Aplicado para a Alta Disponibilidade de Soluções de Realidade Virtual"
Trabalho realizado como parte da avaliação da disciplina Tópicos Especiais em Sistemas de Computação II, no âmbito do Programa de Pós-Graduação em Ciência da Computação da Universidade Federal de Goiás (UFG) - 2023/2.

Aluno: André Luiz de Jesus Gonçalves
andre.goncalves@discente.ufg.br

---

# Resumo
No âmbito das tecnologias imersivas, é imprescindível encontrar soluções que assegurem confiabilidade nas experiências colaborativas em tempo real. Este estudo aborda o uso do Kubernetes-based Event-Driven Autoscaler (KEDA) em simulações de carga para ambientes VR, com foco na alta disponibilidade. Operando nos modos QueueLength e RatePerSecond, o KEDA destaca-se pela eficácia ao ajustar dinamicamente o número de réplicas da aplicação às variações nas métricas de fila, otimizando o desempenho do cluster. Os resultados obtidos apontam a capacidade do KEDA em atender requisitos fundamentais, como resiliência e escalabilidade, essenciais para proporcionar uma experiência contínua aos usuários.

# Experimento
Para investigar a eficácia do KEDA, foi proposto um experimento com o objetivo de verificar o ajuste dinâmico do número de réplicas da aplicação conforme a carga de trabalho. Além disso, pretende-se analisar o desempenho e a viabilidade prática dessa abordagem em atender exigências das aplicações imersivas, como alta confiabilidade e baixa latência.

* O sistema é composto pelo Load Generator, responsável por simular múltiplas conexões, bem como o RabbitMQ, que enfileira as solicitações de conexões. 
* Na sequência o HPA e o KEDA gerenciam o dimensionamento dinâmico da aplicação com base na carga de trabalho detectada na fila do RabbitMQ. 
* A aplicação em si, denominada DynamicScaleApp, é responsável por processar as solicitações. 

Para garantir que a aplicação seja executada de forma eficiente e escalável, o número de réplicas da aplicação é ajustado automaticamente pelo HPA e pelo KEDA conforme necessário. O Process K3s Agent gerencia as operações do lado do cliente e as réplicas da aplicação, enquanto o Process K3s Server coordena e gerencia o cluster Kubernetes como um todo. Essa arquitetura garante uma operação eficiente e escalável da aplicação, adaptando-se dinamicamente às demandas da carga de trabalho.

![arquitetura](https://github.com/LABORA-INF-UFG/dynamic-scale-app/blob/main/imagens/lab.png)

Preparação do ambiente:

Foi projetado um ambiente com dois computadores interconectados em um modelo cliente-servidor. O dispositivo designado como cliente é equipado com um processador de 2 núcleos, operando a 3.20 GHz, e 8 gigabytes de memória RAM. Por sua vez, o servidor, munido de um processador de 4 núcleos a 3.50 GHz, conta com 16 gigabytes de memória RAM. 

* Servidor equipado com Ubuntu 22.04.4 LTS

1. Instalação do curl:

```
sudo apt install curl
```

2. Baixe e instale o k3s:

```
curl -sfL https://get.k3s.io | sh -
```

3. Verifique se o k3s está em execução:

```
sudo systemctl status k3s
```

4. Instalação do Helm:

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

5. Implantação do KEDA com o Helm:

5.1. Adicionar repositório Helm

```
helm repo add kedacore https://kedacore.github.io/charts

```
5.2. Atualizar repositório Helm
```
helm repo update
```
5.3. Instalar o KEDA
```
helm install keda kedacore/keda --namespace keda --create-namespace

```


# Referências 

1. [Curl](https://curl.se/download.html)
2. [K3s](https://k3s.io/)
3. [Helm](https://helm.sh/docs/intro/install/)
4. [KEDA](https://keda.sh/docs/2.13/deploy/)
