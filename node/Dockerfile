FROM node:alpine
LABEL maintainer="datapunt@amsterdam.nl"

# Install ca-certificates bundle inside the docker image and remove the temp folder
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

# Copy certificate
COPY adp_rootca.crt /usr/local/share/ca-certificates/

# Tell node to use openssl ca
ENV NODE_OPTIONS=--use-openssl-ca

# Update new cert
RUN update-ca-certificates
