ARG NODE_VERSION=20

FROM node:${NODE_VERSION}-slim

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

EXPOSE 5173

CMD ["yarn", "dev", "--host", "0.0.0.0"]
