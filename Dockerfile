#dckr_pat_Xie-_iJH6Y3nWsfjs_myJn0cCXw

FROM node:19-alpine3.15 as dev-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --frozen-lockfile


FROM node:19-alpine3.15 as builder
WORKDIR /app
COPY --from=dev-deps /app/node_modules ./node_modules
COPY . .
# RUN yarn test
RUN yarn build

FROM node:19-alpine3.15 as prod-deps
WORKDIR /app
COPY package.json package.json
RUN yarn install --prod --frozen-lockfile


FROM node:19-alpine3.15 as prod
EXPOSE 3000
WORKDIR /app
ENV APP_VERSION=${APP_VERSION}
COPY --from=prod-deps /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

CMD [ "node","dist/main.js"]


#Construir imagen de este dockerfile localmente y correrlo
#docker build --tag pmacdev/graphql-actions:0.0.1 . 
#docker container run -p 3000:3000 pmacdev/graphql-actions:0.0.1

#Correr la imagen que se ha subido a docker hub, en este caso a través de github actions
# docker container run -p 3000:3000 pmacdev/docker-graphql:0.0.2


#docker login -u pmacdev -p dckr_pat_Xie-_iJH6Y3nWsfjs_myJn0cCXw       


######################################
# Como se contruye la imagen con este dockerfile
#  docker build --tag cron-ticker .
#  docker build --tag cron-ticker:1.0.0 .
# el punto . indica el path relativo adonde se encuentra el dockerfile
# en este caso el directorio actual

# Correr un contenedor con la imagen creada
# docker container run cron-ticker
# docker container run -d cron-ticker

# Especificar puerto
# docker container run -p 3000:3000 cron-ticker:castor

# Ejecutar una version con un tag concreto
# docker container run cron-ticker:castor


# Ver el contenido de un container montado
# docker exec -it IDContainer /bin/sh

# renombrar una imagen
# docker image tag cron-ticker:1.0.0 cron-ticker:bufalo
# docker image tag cron-ticker:latest cron-ticker:castor






