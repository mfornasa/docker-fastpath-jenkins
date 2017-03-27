FROM node:6.10.1-alpine

CMD [ "yarn", "start" ]
EXPOSE 3000

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install dependencies
ADD package.json yarn.lock /cache/
RUN cd /cache \
  && yarn \
  && cd /usr/src/app && ln -s /cache/node_modules node_modules

# Copy the app
COPY . /usr/src/app
