FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-e1-1-web"
LABEL org.opencontainers.image.description="Codyssey E1-1 custom NGINX web server"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
