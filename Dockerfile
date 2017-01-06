FROM node:6.9-alpine

WORKDIR /data
ENV NODE PRODUCTION

ADD . /data
RUN npm install

CMD ["npm", "start"]
