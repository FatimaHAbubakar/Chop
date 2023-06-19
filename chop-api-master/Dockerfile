FROM node:18.16.0

WORKDIR /var/www/html

COPY package*.json ./

RUN npm install

COPY . .

RUN npx prisma generate

RUN npm run build

EXPOSE ${PORT}

CMD [ "npm", "run", "start:migrate:prod" ]