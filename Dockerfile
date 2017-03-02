FROM alpine
LABEL maintainer "marc@malexandre.fr"

RUN apk update
RUN apk add wget python py-pip openssl-dev python-dev libffi-dev build-base
RUN rm -rf /var/cache/apk/*

RUN pip install pycrypto

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz --no-check-certificate \
    && tar zxvf google-cloud-sdk.tar.gz \
    && rm google-cloud-sdk.tar.gz \
    && ./google-cloud-sdk/install.sh --usage-reporting=true --path-update=true
ENV PATH /google-cloud-sdk/bin:/google-cloud-sdk/platform/google_appengine/:$PATH
ENV APPENGINE /google-cloud-sdk/platform/google_appengine/
ENV GOPATH /code/golibs
RUN yes | gcloud components update

RUN apk del wget py-pip
RUN mkdir -p /code/golibs

WORKDIR /code
