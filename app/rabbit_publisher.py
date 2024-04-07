import sys
from kombu import Connection, Producer, Exchange, Queue

exchange = Exchange('keda_demo', type='direct')

messages = 1
if len(sys.argv) > 1:
    try:
        messages = int(sys.argv[1])
    except:
        print("Informe um inteiro para o número de mensagens")

with Connection('amqp://user:password@192.168.100.9:5672//') as connection:
    producer = Producer(connection)
    
    for _ in range(0, messages):
        producer.publish({'hello': 'world'},
                         exchange=exchange,
                         routing_key='keda_demo',
                         serializer='json', compression='zlib')
