FROM clojure:openjdk-8-lein-2.9.5
RUN mkdir -p /usr/src/app && \
    apt update && \
    apt install -y git make python3 && \
    apt clean
WORKDIR  /usr/src/app
COPY . ./
RUN make libs && \
    make clean all
CMD ["/bin/sh"]