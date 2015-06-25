# RabbitMQ server #

Simple implementation of the [RabbitMQ server](https://www.rabbitmq.com) [Docker](https://www.docker.com) image based on [Tatum](https://github.com/tutumcloud/tutum-docker-rabbitmq) code.

## Instalation ##

Preferred way to install and using the project is via the [Docker Hub](https://hub.docker.com).

    docker pull apollo13/rabbitmq-server

## Running the RabbitMQ server ##

On development environment, before the starting of the server check existence of running Redis docker image as is described in apollo13/ubuntu README.md

Run the following command to start rabbitmq:

    docker run --name rabbitmq-server -d -p 5672:5672 -p 15672:15672 apollo13/rabbitmq-server

*For [boot2docker](https://github.com/boot2docker/boot2docker-cli) users*: Set port forwarding from [boot2docker](https://github.com/boot2docker/boot2docker/blob/master/doc/WORKAROUNDS.md) to local computer:

    VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port5672,tcp,,5672,,5672";
    VBoxManage modifyvm "boot2docker-vm" --natpf1 "tcp-port15672,tcp,,15672,,15672";

For already running boot2docker virtual:

    VBoxManage controlvm "boot2docker-vm" natpf1 "tcp-port5672,tcp,,5672,,5672";
    VBoxManage controlvm "boot2docker-vm" natpf1 "tcp-port15672,tcp,,15672,,15672";

The first time that you run your container, a new random password will be set.
To get the password, check the logs of the container by running:

    docker logs rabbitmq-server

You will see an output like the following:

    ========================================================================
    You can now connect to this RabbitMQ server using, for example:

        curl --user admin:5elsT6KtjrqV  http://<host>:<port>/api/vhosts

    Please remember to change the above password as soon as possible!
    ========================================================================

In this case, `5elsT6KtjrqV` is the password set.
You can then connect to RabbitMQ:

    curl --user admin:5elsT6KtjrqV  http://<host>:<port>/api/vhosts

Or try to open [Rabbit MQ management](https://www.rabbitmq.com/management.html) from the browser:

    http://localhost:15672

Alternatively you can set up initial username and password while starting the container using environment variables:

    docker run --name rabbitmq-server -d -p 5672:5672 -p 15672:15672 -e RABBITMQ_USER=apollo -e RABBITMQ_PASS=mysecretpassword apollo13/rabbitmq-server

For Development environment you have to set link to docker container with redis for storing credentials for other containers

    docker run --name rabbitmq-server -d -p 5672:5672 -p 15672:15672 --link config-service:config-service apollo13/rabbitmq-server


## Building Docker image locally

Prepare standard named project directory

    mkdir ./rabbitmq-server
    cd ./rabbitmq-server

Preferred way to build the Docker image is via the [GIT](http://git-scm.com).

    git clone git@bitbucket.org:apollo-13/docker-rabbitmq-server.git

Build the image in the root folder `./` of the cloned repository

    docker build -t apollo13/rabbitmq-server .
