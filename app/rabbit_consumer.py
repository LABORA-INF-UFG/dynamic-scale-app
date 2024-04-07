from time import sleep
from kombu import Connection, Exchange, Queue, Consumer, eventloop
from app.utils.logger import logger

exchange = Exchange('keda_demo', type='direct')
queue = Queue('keda_demo', exchange, routing_key='keda_demo')


def handle_message(body, message):
    logger.debug(f'Received message: {body!r}')
    sleep(0.2)
    message.ack()


with Connection('amqp://user:password@192.168.100.9:5672//') as connection:
    with Consumer(connection, queue, callbacks=[handle_message]):
        for _ in eventloop(connection):
            pass
