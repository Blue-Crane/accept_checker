FROM python:3.10.8-slim-buster AS runner

RUN apt-get update
RUN apt-get install -y openjdk-11-jdk openjdk-11-jre
RUN apt-get install -y gcc g++ mono-complete mono-devel pypy3 unzip wget lua5.3 gnucobol ghc ghc-prof ghc-doc gfortran

WORKDIR /pascal
RUN wget "http://pascalabc.net/downloads/PascalABCNETLinux.zip"
RUN unzip "PascalABCNETLinux.zip" "PascalABCNETLinux/*"
RUN echo '#! /bin/sh' >> /bin/pabcnetc
RUN echo 'mono /pascal/PascalABCNETLinux/pabcnetcclear.exe $1' >> /bin/pabcnetc
RUN chmod u+x /bin/pabcnetc

WORKDIR ../rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs/ | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR ../go
RUN wget "https://go.dev/dl/go1.20.5.linux-amd64.tar.gz" -O go.tar.gz
RUN tar -C /usr/local -xzf go.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin

WORKDIR ../node
RUN wget "https://nodejs.org/dist/v18.16.1/node-v18.16.1-linux-x64.tar.xz"
RUN tar -xf node-v18.16.1-linux-x64.tar.xz
RUN mv node-v18.16.1-linux-x64/bin/node /bin/node

WORKDIR ..
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./main.py"]