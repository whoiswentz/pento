FROM postgres:16

RUN apt update \
    && apt install gnupg apt-transport-https lsb-release wget -y

RUN echo "deb https://packagecloud.io/timescale/timescaledb/debian/ $(lsb_release -c -s) main" | tee /etc/apt/sources.list.d/timescaledb.list
RUN wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | apt-key add -

RUN apt update \
    && apt install postgis timescaledb-2-postgresql-16 -y