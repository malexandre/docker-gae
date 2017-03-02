FROM alpine
LABEL maintainer "marc@malexandre.fr"

RUN apk update
RUN apk add wget bash python openssl-dev python-dev libffi-dev build-base
RUN rm -rf /var/cache/apk/*

RUN wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate && python get-pip.py && rm get-pip.py
RUN pip install pycrypto

RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz --no-check-certificate \
    && tar zxvf google-cloud-sdk.tar.gz \
    && rm google-cloud-sdk.tar.gz \
    && ./google-cloud-sdk/install.sh --usage-reporting=true --path-update=true
ENV PATH /google-cloud-sdk/bin:/google-cloud-sdk/platform/google_appengine/:$PATH
ENV APPENGINE /google-cloud-sdk/platform/google_appengine/
RUN yes | gcloud components update
RUN yes | gcloud components install app-engine-go app-engine-python

RUN wget https://gist.githubusercontent.com/malexandre/d7d89ef69be325e15eb54fe3aecb45bd/raw/85c31dffc86b48707e78a0c0b7045d072971f594/update_socket.py --no-check-certificate
RUN python update_socket.py
RUN rm update_socket.py

RUN apk del wget

WORKDIR /code
ADD . /code
