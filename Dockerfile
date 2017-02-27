FROM alpine

RUN apk update && apk add wget bash python openssl-dev python-dev libffi-dev build-base && rm -rf /var/cache/apk/*
RUN wget https://bootstrap.pypa.io/get-pip.py --no-check-certificate && python get-pip.py && rm get-pip.py
RUN pip install pycrypto
RUN wget https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz --no-check-certificate \
    && tar zxvf google-cloud-sdk.tar.gz \
    && rm google-cloud-sdk.tar.gz \
    && ./google-cloud-sdk/install.sh --usage-reporting=true --path-update=true
ENV PATH /google-cloud-sdk/bin:/google-cloud-sdk/platform/google_appengine/:$PATH
RUN yes | gcloud components update
RUN yes | gcloud components install app-engine-go app-engine-python

WORKDIR /code
ADD . /code
