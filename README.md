# Running OpenStreetMap Carto with Docker

This project is assumed to be a replacement for current [OpenStreetMap Carto](https://github.com/gravitystorm/openstreetmap-carto)'s docker facilities. 

## Prerequisites

Docker is available for Linux, macOS and Windows. Apart from Docker Engine itself there is a set of automation tools
commonly used to manage containers. To get OpenStreetMap Carto running you will need [Docker Compose](https://docs.docker.com/compose/) 
and [Dobi](https://dnephin.github.io/dobi/).

* [Install Docker](https://docs.docker.com/engine/installation/)
* [Install Docker Compose](https://docs.docker.com/compose/install/)
* [Install Dobi](https://dnephin.github.io/dobi/install.html)

## Quick start

### Get sources
 
Download openstreetmap-carto release or just grab the latest sources and switch to the fetched directory:

```
$ git clone https://github.com/gravitystorm/openstreetmap-carto.git
$ cd openstreetmap-carto
```

Clone this project into `docker` subdirectory:

```
$ git clone https://github.com/OnkelTem/osmcarto-docker.git docker
```

### Get OSM data

Download OSM data of your interest in osm.pbf format to a file `data.osm.pbf` and place it within your `openstreetmap-carto` directory.

*@Todo: Automate getting and updating OSM data.*

### Run (all-in-one)

To get everything built and running just type:
```
$ dobi start
```
It will pull and build all required Docker images, download fonts, shapefiles, initialize the database and import OSM data into it 
and finally run both Kosmtik and Tiles server (renderd/mod_tile/apache).

Optionally you can first run the building process separately:
```
$ dobi build
```
which is a wise thing to do, as it takes a while to download and build everything so you can do something else in the meantime.
Afterwards running `dobi start` will immediately start the containers.

You can now browse to [http://localhost:6789](http://localhost:6789) to view the output of Kosmtik.

Tiles server receives requests on [http://localhost:8097](http://localhost:8097) which you can use as a base uri for [QGis](https://www.qgis.org) 
or other software. Also, opening this URL in browser will load simple page for viewing OSM map.

To stop it anytime just type:
```
$ dobi stop
```

### Running Kosmtik/Tiles server separately

If you don't need both Kosmtik and Tiles server just run them separately.

* Kosmtik
  * start: `dobi kosmtik-start`
  * stop: `dobi kosmtik-stop`
* Tiles server
  * start: `dobi tiles-start`
  * stop: `dobi tiles-stop`
  
## Architecture

Docker configuration is comprised with few `docker-compose.*.yml` files and one `dobi.yaml` file.

### Docker Compose

This setup uses three Docker Compose files:

* `docker-compose.db.yml` - declares PostGIS database container
* `docker-compose.kosmtik.yml` - declares Kosmtik container
* `docker-compose.tiles.yml` - declares Tiles container

**NOTE:** You don't need to run `docker-compose` tool manually as its files are used internally by Dobi.

### Dobi

Dobi reads its configuration from `dobi.yaml` file which defines image, mounts, jobs and "services" for Dobi automation tool.

You run Dobi tasks as simple as:
```
$ dobi <task>
```
where `task` is the name of a *resource* which is usually a job or an alias. To learn more about Dobi check out its [documentation](https://dnephin.github.io/dobi/).

Here is the list of all jobs and aliases defined in this project: 

* Jobs
  * `shapefiles` - downloads and indexes shapefiles of world boundaries
  * `fonts` - downloads fonts populating `osmcarto_fonts` volume
  * `import` - imports OSM data from `data.osm.pbf` into PostGIS database using [osm2pgsql](https://github.com/openstreetmap/osm2pgsql) tool
  * `compile` - compiles `project.mml` to `style.xml`
* Aliases
  * `build` - builds all docker images
  * `init` - runs `shapefiles`, `fonts` and `import` jobs
  * `kosmtik-start` - runs Kosmtik
  * `kosmtik-stop` - stops Kosmtik
  * `tiles-start` - Runs tiles server
  * `tiles-stop` - Stops tiles server
  * `start` - Runs both Kosmtik and tiles server (this is also the default Dobi action which executes when you run `dobi` without parameters) 
  * `stop` - Stops both Kosmtik and tiles server

## Volumes

Docker Volumes are pieces of data which are mounted into containers as directories. They are used to make data persistent i.e. to not get it disappeared
across container runs. Usually they're used either for big or variable data like databases, caches and etc, so that one can manage them
independently.

This project uses the next volumes:

* `osmcarto_db` - a volume with PostGIS database.
* `osmcarto_fonts` - a volume with fonts used by OSM carto.
* `osmcarto_tiles` - a volume with the tiles server cached tiles.

You can list them with `docker volume ls`. If you don't need some data anymore, first stop the corresponding containers if they're running (i.e. stop dobi tasks) 
and then remove the volume with `docker volume rm <volume_name>`.  

