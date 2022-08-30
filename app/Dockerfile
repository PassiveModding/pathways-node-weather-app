FROM node:18

# Create app directory
WORKDIR /opt/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY package*.json ./

RUN npm install

COPY . /opt/app

# app runs on port 3000 by default (node: this is the interna port)
EXPOSE 3000
CMD [ "npm", "run", "start" ]