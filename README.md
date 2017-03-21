# Calibre Web

[![Docker Stars](https://img.shields.io/docker/stars/technosoft2000/calibre-web.svg)]()
[![Docker Pulls](https://img.shields.io/docker/pulls/technosoft2000/calibre-web.svg)]()
[![](https://images.microbadger.com/badges/image/technosoft2000/calibre-web.svg)](https://microbadger.com/images/technosoft2000/calibre-web "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/technosoft2000/calibre-web.svg)](https://microbadger.com/images/technosoft2000/calibre-web "Get your own version badge on microbadger.com")

## Calibre Web - Manage your Calibre e-book collection ##

Calibre Web is a web app providing a clean interface for browsing, reading and downloading eBooks using an existing Calibre database.

Calibre Web comes with the following features:

 * Bootstrap 3 HTML5 interface
 * full graphical setup
 * User management
 * Admin interface
 * User Interface in english, french, german, polish, simplified chinese, spanish
 * OPDS feed for eBook reader apps
 * Filter and search by titles, authors, tags, series and language
 * Create custom book collection (shelves)
 * Support for editing eBook metadata
 * Support for converting eBooks from EPUB to Kindle format (mobi/azw)
 * Restrict eBook download to logged-in users
 * Support for public user registration
 * Send eBooks to Kindle devices with the click of a button
 * Support for reading eBooks directly in the browser (.txt, .epub, .pdf)
 * Upload new books in PDF, epub, fb2 format
 * Support for Calibre custom columns
 * Fine grained per-user permissions
 * Self update capability

If you want to know more you can head over to the Calibre Web project site: https://hub.docker.com/r/janeczku/calibre-web/.

## Updates ##

**2017-03-21 - v1.1.1**
 * added creation of gdrive.db symlink at /books/gdrive.db for external access like backup possibility

**2017-03-20 - v1.1.0**
 * added the optional Google Drive integration
 * added creation of app.db symlink at /books/app.db for external access like backup possibility

**2017-03-11 - v1.0.0**
 * calibre-web image is based now on ```technosoft2000/alpine-base:3.5-1.0.0```
 * updated Dockerfile to the latest state needed to run Calibre Web (Latest commit dbf07cb) correctly

## Features ##

 * running Calibre Web under its own user (not root)
 * changing of the UID and GID for the Calibre Web user

## Configuration at first launch ''
 1. Point your browser to `http://hostname:<HTTP PORT>` e.g. `http://hostname:8083`
 2. Set Location of your Calibre books folder to the path of the folder where you mounted your Calibre folder in the container, which is by default `\books`.
    So enter at the field __Location of Calibre database__ the mapped volume `\books`.
 3. Hit __Submit__ then __Login__.

Default admin login:
 * __Username:__ admin
 * __Password:__ admin123

After successful login change the default password and set the email adress.

To access the OPDS catalog feed, point your Ebook Reader to http://hostname:8080/opds

## Usage ##

__Create the container:__

```
docker create --name=calibre-web --restart=always \
-v <your Calibre books folder>:/books \
[-e APP_REPO=https://github.com/janeczku/calibre-web.git \]
[-e APP_BRANCH=master \]
[-e SET_CONTAINER_TIMEZONE=true \]
[-e CONTAINER_TIMEZONE=<container timezone value> \]
[-e PGID=<group ID (gid)> -e PUID=<user ID (uid)> \]
-p <HTTP PORT>:8083 \
technosoft2000/calibre-web
```

__Example:__

```
docker create --name=calibre-web --restart=always \
-v /volume1/books:/books \
-v /etc/localtime:/etc/localtime:ro \
-e PGID=65539 -e PUID=1029 \
-p 8083:8083 \
technosoft2000/calibre-web
```

or

```
docker create --name=calibre-web --restart=always \
-v /volume1/books:/books \
-e SET_CONTAINER_TIMEZONE=true \
-e CONTAINER_TIMEZONE=Europe/Vienna \
-e PGID=65539 -e PUID=1029 \
-p 8083:8083 \
technosoft2000/calibre-web
```

__Start the container:__
```
docker start calibre-web
```

## Parameters ##

### Introduction ###
The parameters are split into two parts which are separated via colon.
The left side describes the host and the right side the container. 
For example a port definition looks like this ```-p external:internal``` and defines the port mapping from internal (the container) to external (the host).
So ```-p 8080:80``` would expose port __80__ from inside the container to be accessible from the host's IP on port __8080__.
Accessing http://'host':8080 (e.g. http://192.168.0.10:8080) would then show you what's running **INSIDE** the container on port __80__.

### Details ###
* `-p 8083` - http port for the web user interface
* `-v /books` - local path which contains the Calibre books and the necessary `metadata.db`  which holds all collected meta-information of the books
* `-v /etc/localhost` - for timesync - __optional__
* `-e APP_REPO` - set it to the Calibre Web GitHub repository; by default it uses https://github.com/janeczku/calibre-web.git - __optional__
* `-e APP_BRANCH` - set which Calibre Web GitHub repository branch you want to use, __master__ (default branch) - __optional__
* `-e SET_CONTAINER_TIMEZONE` - set it to `true` if the specified `CONTAINER_TIMEZONE` should be used - __optional__
* `-e CONTAINER_TIMEZONE` - container timezone as found under the directory `/usr/share/zoneinfo/` - __optional__
* `-e PGID` for GroupID - see below for explanation - __optional__
* `-e PUID` for UserID - see below for explanation - __optional__

### Container Timezone

In the case of the Synology NAS it is not possible to map `/etc/localtime` for timesync, and for this and similar case
set `SET_CONTAINER_TIMEZONE` to `true` and specify with `CONTAINER_TIMEZONE` which timezone should be used.
The possible container timezones can be found under the directory `/usr/share/zoneinfo/`.

Examples:

 * ```UTC``` - __this is the default value if no value is set__
 * ```Europe/Berlin```
 * ```Europe/Vienna```
 * ```America/New_York```
 * ...

__Don't use the value__ `localtime` because it results into: `failed to access '/etc/localtime': Too many levels of symbolic links`

## User / Group Identifiers ##
Sometimes when using data volumes (-v flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user PUID and group PGID. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

In this instance PUID=1001 and PGID=1001. To find yours use id user as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Additional ##
Shell access whilst the container is running: `docker exec -it calibre-web /bin/bash`

Upgrade to the latest version of Calibre Web: `docker restart calibre-web`

To monitor the logs of the container in realtime: `docker logs -f calibre-web`

---

## For Synology NAS users ##

Login into the DSM Web Management
* Open the Control Panel
* Control _Panel_ > _Privilege_ > _Group_ and create a new one with the name 'docker'
* add the permissions for the directories 'downloads', 'video' and so on
* disallow the permissons to use the applications
* Control _Panel_ > _Privilege_ > _User_ and create a new on with name 'docker' and assign this user to the group 'docker'

Connect with SSH to your NAS
* after sucessful connection change to the root account via
```
sudo -i
```
or
```
sudo su -
```
for the password use the same one which was used for the SSH authentication.

* create a 'docker' directory on your volume (if such doesn't exist)
```
mkdir -p /volume1/docker/
chown root:root /volume1/docker/
```

* get your Docker User ID and Group ID of your previously created user and group
```
id docker
uid=1029(docker) gid=100(users) groups=100(users),65539(docker)
```

* get the Docker image
```
docker pull technosoft2000/calibre-web
```

* create a Docker container (take care regarding the user ID and group ID, change timezone and port as needed)
```
docker create --name=calibre-web --restart=always \
-v /volume1/books:/books \
-e SET_CONTAINER_TIMEZONE=true \
-e CONTAINER_TIMEZONE=Europe/Vienna \
-e PGID=65539 -e PUID=1029 \
-p 8083:8083 \
technosoft2000/calibre-web
```

* check if the Docker container was created successfully
```
docker ps -a
CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS               NAMES
40cc1bfaf7be        technosoft2000/calibre-web      "/bin/bash -c /init/s" 8 seconds ago       Created 
```

* start the Docker container
```
docker start calibre-web
```

* analyze the log (stop it with CTRL+C)
```
docker logs -f calibre-web

        ,----,                                   
      ,/   .`|                                   
    ,`   .'  : .--.--.        ,----,        ,-.  
  ;    ;     //  /    '.    .'   .' \   ,--/ /|  
.'___,/    ,'|  :  /`. /  ,----,'    |,--. :/ |  
|    :     | ;  |  |--`   |    :  .  ;:  : ' /   
;    |.';  ; |  :  ;_     ;    |.'  / |  '  /    
`----'  |  |  \  \    `.  `----'/  ;  '  |  :    
    '   :  ;   `----.   \   /  ;  /   |  |   \   
    |   |  '   __ \  \  |  ;  /  /-,  '  : |. \  
    '   :  |  /  /`--'  / /  /  /.`|  |  | ' \ \ 
    ;   |.'  '--'.     /./__;      :  '  : |--'  
    '---'      `--'---' |   :    .'   ;  |,'     
                        ;   | .'      '--'       
                        `---'                    

      PRESENTS ANOTHER AWESOME DOCKER IMAGE
      
      ~~~~~         Calibre Web       ~~~~~
                                           
[INFO] Docker image version: 1.0.0
[INFO] Create group calibre with id 65539
[INFO] Create user calibre with id 1029
[INFO] Current active timezone is UTC
Sat Mar 11 20:39:00 CET 2017
[INFO] Container timezone is changed to: Europe/Vienna
[INFO] Change the ownership of /calibre-web (including subfolders) to calibre:calibre
[INFO] Current git version is:
git version 2.11.1
[INFO] Checkout the latest Calibre-Web version ...
[INFO] ... git clone -b master --single-branch https://github.com/janeczku/calibre-web.git /calibre-web/app -v
Cloning into '/calibre-web/app'...
POST git-upload-pack (165 bytes)
[INFO] Autoupdate is active, try to pull the latest sources for Calibre-Web ...
[INFO] ... current git status is
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working tree clean
dbf07cb593ef29b733b74aaf3abb2b412e7516ac
[INFO] ... pulling sources
Already up-to-date.
[INFO] ... git status after update is
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working tree clean
dbf07cb593ef29b733b74aaf3abb2b412e7516ac
[INFO] Launching Calibre-Web ...
```
