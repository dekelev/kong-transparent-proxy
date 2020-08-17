# kong-transparent-proxy
Kong plugin that acts as a transparent HTTP proxy and forward requests according to the `Host` request header.

```dockerfile
version: '3.8'
services:
  kong-proxy:
    image: kong:2.1.1-alpine
    container_name: kong-proxy
    networks:
      - app
    ports:
      - 8080:8000
    volumes:
      - ./config/kong.yml:/etc/kong/kong.yml
      - ./plugins/transparent-proxy:/etc/kong/plugins/transparent-proxy
    environment:
      KONG_DATABASE: 'off'
      KONG_DECLARATIVE_CONFIG: /etc/kong/kong.yml
      KONG_PLUGINS: bundled,transparent-proxy
      KONG_LUA_PACKAGE_PATH: /etc/?.lua
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ERROR_LOG: /dev/stderr

      # Increase body size limit
      # KONG_NGINX_HTTP_CLIENT_MAX_BODY_SIZE: 100k
      # KONG_NGINX_PROXY_CLIENT_BODY_BUFFER_SIZE: 100k

      # Increase headers size limit
      # KONG_NGINX_PROXY_PROXY_BUFFERS: '8 8k'
      # KONG_NGINX_PROXY_PROXY_BUFFER_SIZE: 8k

networks:
  app:
    driver: bridge
```

Deploy with Docker and access the proxy at `http://localhost:8080`.
