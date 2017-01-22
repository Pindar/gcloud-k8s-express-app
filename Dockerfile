FROM node:6.9-alpine

WORKDIR /data
ENV NODE_ENV production

ADD . /data
RUN export NODE_ENV=production && npm install

CMD ["npm", "start"]
