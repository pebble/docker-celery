FROM python:3.4-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user
WORKDIR /home/user

RUN pip install redis

ENV CELERY_VERSION 3.1.19

RUN pip install celery=="$CELERY_VERSION"

RUN { \
	echo 'import os'; \
    echo 'import ast'; \
    echo "BROKER_URL = os.environ.get('CELERY_BROKER_URL', 'amqp://')"; \
    echo "BROKER_TRANSPORT_OPTIONS = ast.literal_eval(os.environ.get('CELERY_BROKER_TRANSPORT_OPTIONS', '{}'))"; \
} > celeryconfig.py

# --link some-rabbit:rabbit "just works"
ENV CELERY_BROKER_URL amqp://guest@rabbit
ENV CELERY_BROKER_URL '{}'

USER user
CMD ["celery", "worker"]
