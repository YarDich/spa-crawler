FROM node:21-alpine AS development

WORKDIR /app
COPY package*.json tsconfig*.json nest-cli.json ./
RUN npm ci

COPY ./src ./src
RUN npm run build

FROM node:21-alpine as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

# Tell Puppeteer to skip installing Chrome. We'll be using the installed package.
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Installs latest Chromium package.
RUN apk add --no-cache chromium

WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=development /app/dist ./dist

CMD ["node", "dist/main"]