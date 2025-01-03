FROM node:18-alpine
RUN apk add --no-cache bash shadow curl
ENV NODE_ENV=production
EXPOSE 6673
RUN groupadd -r spacex && useradd -r -g spacex spacex
WORKDIR /app
ENTRYPOINT [ "/app/start.sh" ]
COPY --chown=spacex:spacex package.json package-lock.json /app/
RUN npm install
COPY --chown=spacex:spacex . .

USER spacex