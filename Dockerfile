FROM tiangolo/uwsgi-nginx-flask:python3.6

ENV FLASK_APP=/app/app/main.py

COPY ./app /app