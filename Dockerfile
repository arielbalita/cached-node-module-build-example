# Purpose - Leverage Docker multi-stage layers to cache node_modules and achieve faster build times

#Stage 1 - Create cached node_modules.
# Only rebuild layer if package.json has changed
FROM node:10.15-alpine as node_cache
WORKDIR /cache/
COPY package.json .
# Uncomment below if you're using .npmrc
# COPY .npmrc .
RUN npm prune 
RUN npm install

#Stage 2 - Builder root with Chromium installed
FROM zenika/alpine-chrome
USER root
RUN apk add --no-cache make gcc g++ python git nodejs nodejs-npm yarn \
	&& rm -rf /var/lib/apt/lists/* \
    /var/cache/apk/* \
    /usr/share/man \
    /tmp/*
WORKDIR /root/
COPY --from=node_cache /cache/ .
# Copy source files, and possibily invalidate so we have to rebuild
COPY . . 
ENTRYPOINT ["npm", "run"]
