FROM alpine
LABEL maintainer "marc@malexandre.fr"

RUN apk update
RUN apk add wget python openssl-dev python-dev libffi-dev build-base
RUN rm -rf /var/cache/apk/*

RUN wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate && python get-pip.py && rm get-pip.py
RUN pip install pycrypto

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz --no-check-certificate \
    && tar zxvf google-cloud-sdk.tar.gz \
    && rm google-cloud-sdk.tar.gz \
    && ./google-cloud-sdk/install.sh --usage-reporting=true --path-update=true
ENV PATH /google-cloud-sdk/bin:/google-cloud-sdk/platform/google_appengine/:$PATH
ENV APPENGINE /google-cloud-sdk/platform/google_appengine/
ENV GOPATH /code/golibs
RUN yes | gcloud components update

RUN apk del wget
RUN pip uninstall --yes pip setuptools
RUN mkdir -p /code/golibs

WORKDIR /code
