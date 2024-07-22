# Dockerizing Django with Postgres, Gunicorn, and Nginx

## Want to learn how to build this?

Check out the [tutorial](https://testdriven.io/dockerizing-django-with-postgres-gunicorn-and-nginx).

## Want to use this project?

### Development

Uses the default Django development server.

1. Rename `.env.dev.example` to `.env`.
2. Update the environment variables in the `docker-compose.yml` and `.env` files.
3. Build the images and run the containers:

    ```bash
    $ docker-compose up -d --build
    ```

    Test it out at [http://localhost:8000](http://localhost:8000). The `app` folder is mounted into the container and your code changes apply automatically.

### Production

Uses `gunicorn` + `nginx`.

1. Rename `.env.prod.example` to `.env`. Update the environment variables.
2. Build the images and run the containers:

    ```bash
    $ docker-compose -f docker-compose.prod.yml up -d --build
    ```

    Test it out at [http://localhost:1337](http://localhost:1337). No mounted folders. To apply changes, the image must be re-built.
