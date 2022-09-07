FROM node:18

# Create app directory
WORKDIR /usr/scr/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install

COPY . .

# app runs on port 3000 by default (node: this is the internal port)
EXPOSE 3000
CMD [ "npm", "run", "start" ]