FROM nginx:1.30.4-alpine3.24@sha256:97d490c12ba55b4946b01546d1c3ed324e8d41ab1c9fcb2a616aa470620e5b46

LABEL org.opencontainers.image.title="codyssey-e1-1-web"
LABEL org.opencontainers.image.description="Codyssey E1-1 custom NGINX web server"
LABEL org.opencontainers.image.source="https://github.com/gahyun1004/codyssey-training-e1-1"

COPY site/ /usr/share/nginx/html/

EXPOSE 80
