FROM ubuntu:22.04
RUN apt update
RUN apt install -y curl
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN apt install openjdk-17-jdk -y

WORKDIR /app
COPY docker_run.sh .

ADD target/ollama_connector/lib    /app/lib
ADD target/ollama_connector        /app

ENTRYPOINT ["sh", "docker_run.sh"]



