FROM alpine:latest

RUN apk add --no-cache curl bash unzip
WORKDIR /app

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 10000

CMD ["./start.sh"]