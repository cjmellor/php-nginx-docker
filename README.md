# A PHP Docker Container

This container allows you to run a PHP application.

## Services used

* PHP-FPM (v7)
* Alpine
* NGINX
* Supervisor
* [H5BP](https://github.com/h5bp/server-configs-nginx)

### PHP

PHP-FPM is used and has some custom configuration files to make the service run as best as possible.

### Alpine

To keep the container size down, the lightweight Linux distribution Alpine is used.

### NGINX

NGINX is used as the proxy backend

### Supervisor

Supervisor is included as it's very popular to use, especially in software like Laravel

### H5BP

H5BP's NGINX server configs are used to make the NGINX server configurations a tight and secure as possible.

## Disclaimer

This was used for a project for work, so it might not be suited to you out of the box. I suggest reading the configs and Dockerfile and amending to how to see fit.

This isn't a "Getting Started" package at all, it is assumed you have some prior knowledge of how to use Docker.
