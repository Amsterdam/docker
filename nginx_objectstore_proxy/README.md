NGINX docker
============

The `Dockerfile` in this directory is based on the `Dockerfile` from the [official NGINX docker repository](https://github.com/nginxinc/docker-nginx), specifically the one in [`stable/alpine`](https://github.com/nginxinc/docker-nginx/blob/master/stable/alpine/Dockerfile)

The main differences with the standard nginx docker:

1.  The non-standard module [ngx_http_proxy_connect_module](https://github.com/chobits/ngx_http_proxy_connect_module) is added, and the necessary patch to the NGINX code is applied.
2.  (TODO!!!) The default configuration is modified to make nginx act as a proxy to our object stores.
