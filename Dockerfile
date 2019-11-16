FROM ubuntu:16.04
MAINTAINER Asik Rasool "rasoolasik1@gmail.com"
RUN apt-get update -y
RUN apt-get install -y python-pip python-dev build-essential
COPY . /app
WORKDIR /app
RUN pip install -r requirement.txt
ENTRYPOINT ["python"]
CMD ["hello_world.py"]

# tell docker what port to expose
EXPOSE 5000