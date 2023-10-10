FROM ubuntu:22.04
RUN apt-get update && apt-get install -y jq
COPY ./src /app/
WORKDIR /app

CMD ["bash", "./contact_controller.sh"]
