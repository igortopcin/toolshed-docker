# Galaxy Toolshed Docker Image

## Building the docker image
Make sure you init and update ``galaxy`` submodule by doing:
```shell
git submodule init
git submodule update
```

The commands above will fetch the latest version of galaxy. You are now prepared to build the docker image:

```shell
docker build -t toolshed .
```

## Running the toolshed
The following will run toolshed on host port 9009:
```shell
docker run -d --name toolshed -p 9009:9009 toolshed
```

## Bootstrapping
This docker image has already been bootstrapped, that is, it contains all the necessary tables and initial application data based on http://toolshed.g2.bx.psu.edu. The application was also initialized with a default admin account: dev-mig / dev-mig (email: dev@mig.ime.usp.br).

We run sqllite database. However, if you prefer using postgres as your database, you can easily extend this Dockerfile, recreate the contents of ``/data/`` and redo the bootstrapping process (see the Dockerfile for more information). You will propably want to change some of the configuration parameters in ``config/tool_shed.ini`` before running the bootstrapping script - see ``config/bootstrap.sh`` as a suggestion of bootstrap script.

## Mounting ``/data``
If you choose to mount /data, you will need to re-do the bootstrapping by hand. To do so, just do the following:
```shell
# first: run the container...

```

## Setting up a dedicated postgres database
Create a new user for Toolshed in your postgres:
```shell
su postgres

createuser -P toolshed
#choose a password for xnat user and then retype it.

createdb -O toolshed toolshed
```

Then, you will need to rebuild this container, changing a couple of config params in ``config/toolshed.ini``:

```ini
# Database connection
# database_file = /data/community.sqlite
# You may use a SQLAlchemy connection string to specify an external database instead
database_connection = postgresql://toolshed:password@postgres:5432/toolshed
```

Finally, run ``docker build -t toolshed .`` and then you are ready to run toolshed with postgres. Examples:

```shell
docker run -d --name toolshed --link postgres -p 9009:9009 toolshed
```

```shell
docker run -d --name toolshed --add-host postgres:10.8.0.26 -p 9009:9009 toolshed
```
