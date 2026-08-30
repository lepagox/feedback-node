FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

# dn we could actually comment out the COPY command while we have a bind mount to our source
# code, but the bind mount is meant for dev purposes only ("live" code updates) and would not
# be there for production deployments
COPY . .

# dn a build time arg that may only be used in Dockerfile (not by any code)
# useful for deploying to different environments as you don't need to change this file
# dn2 moved to below COPY from below FROM as we don't really want to re-rund npm install
# every time we change this value
ARG DEFAULT_PORT=80

# dn set PORT to be 80 (not hard-coded into server.js) - updated to refer to ARG above
# also could add .env file and refer to that in run command with --env-file ./.env
ENV PORT=${DEFAULT_PORT}

# dn now that we've set PORT above we can refer to it in EXPOSE instead of hard-coded 80
EXPOSE $PORT

# dn the below line creates an anonymous volume which won't persist when container 
# is shutdown...need to define on command line instead, e.g. "-v feedback:/app/feedback"
# VOLUME [ "/app/node_modules" ]

# dn but here we show we can add an anonymous volume for temp data so that it
# is not managed in the container but in the fs (small performance improvement)
# btw only anonymous volumes may be defined in Dockerfile
# dn2 now we remove this volume here as we're also putting it in the run command since our 
# bind mount is now read-only to the container so we want to ensure this subfolder is writeable
# VOLUME [ "/app/temp" ]

#CMD [ "node", "server.js" ]
# use npm and start script, which under the hood uses nodemon (see package.json)
CMD [ "npm", "start" ]