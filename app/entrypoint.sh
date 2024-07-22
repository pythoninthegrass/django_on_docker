#!/usr/bin/env bash

if [ "$DATABASE" = "postgres" ]; then
    echo "Waiting for postgres..."

    while ! nc -z "$SQL_HOST" "$SQL_PORT"; do
      	sleep 5
    done

    echo "PostgreSQL started"
fi

if [ $# -eq 1 ]; then
	case "$1" in
		-d|--dev)
			python manage.py flush --no-input
			;;
		*)
			echo "Argument $1 not recognized. Exiting..."
			exit 1
			;;
	esac
fi

python manage.py migrate --no-input

exec "$@"
