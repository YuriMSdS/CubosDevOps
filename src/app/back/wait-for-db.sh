#!/bin/bash
HOST=$1
PORT=$2
USER=$3
PASSWORD=$4
DB_NAME=$5

echo "Aguardando o banco de dados $HOST:$PORT..."

until nc -z -v -w30 $HOST $PORT
do
  echo "Esperando o Postgre..."
  sleep 1
done

echo "Banco de dados disponível! Conectando..."
until PGPASSWORD=$PASSWORD psql -h $HOST -U $USER -d $DB_NAME -c '\q' 2>/dev/null
do
  echo "Esperando o banco de dados estar pronto para conexões..."
  sleep 1
done

echo "Banco de dados está pronto!"
