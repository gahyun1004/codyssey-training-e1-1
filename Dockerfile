FROM nginx:1.30.4-alpine3.24

LABEL org.opencontainers.image.title="codyssey-e1-1-web"
LABEL org.opencontainers.image.description="Codyssey E1-1 custom NGINX web server"
LABEL org.opencontainers.image.source="https://github.com/gahyun1004/codyssey-training-e1-1"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
