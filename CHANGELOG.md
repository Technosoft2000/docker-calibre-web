**2018-08-21 - v1.2.1**

 * fixed issue that the execution of Calibre's `ebook-convert` didn't worked correct,
   therefore changed the internal Calibre path from `/opt/calibre/bin` to `/opt/calibre`;
   thanks to @bodybybuddha and @adocampo for testing and finding a solution for this issue;
   see for details at issue #28 **Integrate ebook-converter (calibre binaries)**
 * @OzzieIsaacs will provide in the near future a fix of `worker.py` so that the call of `ebook-convert`
   works sucessfully from the Calibre-Web UI too, thanks
 * **Important:** 
   at **Admin** -> **Basic Configuration** -> **E-Book converter** you've to set the converter which you want to use:
   - for the option **Use Kindlegen** set the **Path to convertertool** to `/calibre-web/app/vendor/kindlegen`
     and at **About** you will see then `kindlegen	Amazon kindlegen(Linux) V2.9 build 1028-0897292`
   - for the option **Use calibre's ebook converter** set the **Path to convertertool** to `/opt/calibre/ebook-convert`
     and at **About** you will see then `Calibre converter	ebook-convert (calibre 3.29.0)`

**2018-08-15 - v1.2.0**

 * new base image [technosoft2000/alpine-base:3.8-1](https://hub.docker.com/r/technosoft2000/alpine-base/) based on Alpine 3.8
 * integrated Alpine **glibc v2.28-r0** for original Calibre
 * integrated enhancements from [jim3ma/docker-calibre-web](https://github.com/jim3ma/docker-calibre-web) needed for calibre **ebook-convert** command line tool
 * **Important:** 
   at **Admin** -> **Basic Configuration** -> **E-Book converter** you've to set the converter which you want to use:
   - for the option **Use Kindlegen** set the **Path to convertertool** to `/calibre-web/app/vendor/kindlegen`
     and at **About** you will see then `kindlegen	Amazon kindlegen(Linux) V2.9 build 1028-0897292`
   - for the option **Use calibre's ebook converter** set the **Path to convertertool** to `/opt/calibre/bin/ebook-convert`
     and at **About** you will see then `Calibre converter	ebook-convert (calibre 3.29.0)`
 * **Known issue:**
   if you map the old/existing app volume like `-v /volume1/docker/apps/calibre-web/app:/calibre-web/app`
   then you'll get the following issue at startup

```
[INFO] Checkout the latest Calibre-Web version ...
[INFO] Autoupdate is active, try to pull the latest sources for Calibre-Web ...
[INFO] ... current git status is
fatal: not a git repository (or any parent up to mount point /calibre-web)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
[INFO] ... pulling sources
fatal: not a git repository (or any parent up to mount point /calibre-web)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
[INFO] ... git status after update is
fatal: not a git repository (or any parent up to mount point /calibre-web)
Stopping at filesystem boundary (GIT_DISCOVERY_ACROSS_FILESYSTEM not set).
```

   To solve the issue delete the old files at `-v /volume1/docker/apps/calibre-web/app:/calibre-web/app`
   before you create and start the container.

| **Program library** | **Installed Version** |
| ------------------- | --------------------- |
| Sqlite	            | v3.24.0               |
| lxml	              | v4.2.4.0              |
| Image Magick	      | ImageMagick 6.9.10-10 Q16 x86_64 2018-08-15 https://www.imagemagick.org |
| kindlegen	          | Amazon kindlegen(Linux) V2.9 build 1028-0897292 |
| Flask	              | v1.0.2                |
| Babel	              | v2.6.0                |
| PyPdf	              | v1.26.0               |
| pySqlite	          | v2.6.0                |
| Python	            | 2.7.15 (default, May 10 2018, 21:00:22) [GCC 6.4.0] |
| Sqlalchemy	        | v1.2.10               |
| Iso 639	            | v0.4.5                |
| Gevent	            | v1.3.5                |
| Requests	          | v2.19.1               |
| Flask Login	        | v0.4.1                |
| Flask Principal	    | v0.4.0                |

**2018-04-14 - v1.1.11**
 
 * exposed additional directories (see ticket #24)
   `-v /calibre-web/app` - local path for Calibre Web application files
   `-v /calibre-web/kindlegen` - local path for Calibre Web kindlegen application
 * added support for setting the Calibre Web application folder (see ticket #27);
   map volume `-v /calibre-web/app` if you want to use Google Drive 
 * updated python `requirements` and `optional requirements`at dockerfile according to
   - https://github.com/janeczku/calibre-web/blob/master/requirements.txt
   - https://github.com/janeczku/calibre-web/blob/master/optional-requirements.txt
 * added __Container Directory Structure__ information at README.md (see ticket #24)
 * kindlegen archive will be downloaded on container startup into `/calibre-web/kindlegen` 
   and is not directly included in the image anymore
 * ownership of symlink of `app.db`, `gdrive.db` and `kindlegen` is changed from _root_ to the _calibre_ user & group 

 __Example:__
```
docker create --name=calibre-web --restart=always \
-v /volume1/books/calibre:/books \
-v /volume1/docker/apps/calibre-web/app:/calibre-web/app \
-v /volume1/docker/apps/calibre-web/config:/calibre-web/config \
-v /volume1/docker/apps/calibre-web/kindlegen:/calibre-web/kindlegen \
-e PGID=65539 -e PUID=1029 \
-p 8083:8083 \
technosoft2000/calibre-web
```

**2017-11-04 - v1.1.10**

 * added support for a configuration directory (as asked in ticket #13), 
   where the configuration related files like `app.db` and `gdrive.db` will be stored;
   be aware that `metadata.db` will be still stored at the books directory which is required by the original Calibre application
 * new options `-v <your Calibre Web config folder>:/calibre-web/config` and `-e USE_CONFIG_DIR=true` to setup the configuration directory

**2017-10-30 - v1.1.9**

 * new base image [technosoft2000/alpine-base:3.6-3](https://hub.docker.com/r/technosoft2000/alpine-base/)
 * supports also __root__ as user and group via __PGID__ and __PUID__ value 0 correct

```
[INFO] Docker image version: 1.1.9
[INFO] Alpine Linux version: 3.6.2
[WARNING] A group with id 0 exists already [in use by root] and will be modified.
[WARNING] The group root will be renamed to calibre
[WARNING] A user with id 0 exists already [in use by root].
[WARNING] Create user calibre with temporary user id 999.
[WARNING] Assign non-unique user id 0 to created user calibre
...
```

**2017-09-10 - v1.1.8**

 * added additional check to proof if the `vendor` directory is available and create it if needed;
   this bugfix is needed because the default `vendor` directory was removed from the [janeczku/calibre-web](https://github.com/janeczku/calibre-web) sources - see https://github.com/janeczku/calibre-web/commit/b494b6b62af5aaa79d22b3cb80afc5420b6de621
 * due the above bugfix the `kindlegen` symlink works again and is usable at __Calibre Web__

**2017-08-19 - v1.1.7**

 * added python library `unidecode` to required dependencys - see also at [janeczku/calibre-web](https://github.com/janeczku/calibre-web) 
   issue [Transliteration of folders and filenames](https://github.com/janeczku/calibre-web/issues/257)
 * added initial Calibre `metadata.db` and `metadata_db_prefs_backup.json` 
   to support the case that the container can be started without an already existing Calibre library - see also at issue #8 __metadata.db__

**2017-07-29 - v1.1.6**

 * fixed issue with ImageMagick and Wand - the error 'You probably had not installed ImageMagick library.' was shown at `calibre-web.log`;
   Alpine 3.6 delivers already ImageMagick 7 which isn't supported by Wand yet, due this ImageMagick 6 has to be compiled from source.
   See also at https://github.com/dahlia/wand/issues/287
 * loading of book metadata works now too because of the ImageMagick fix
 * updated README.MD with information how to detect image version and how to monitor `calibre-web.log`

**2017-07-29 - v1.1.5**

 * fixed issue #9 - [BUG] In version 1.1.4 /books folder doesn't have write access
 * enhanced user permisson check to use UID in addition to username; 
   successfully tested with /books permissons 770, 755, 700 
 * added additional output at permission checks
 * enhanced check of symlinks like app.db, gdrive.db, ...

**2017-07-23 - v1.1.4**

 * fixed issue #5 - Unable to create /tmp/Mobi
 * fixed issue #6 - Not possible for symlinks to be created

**2017-06-03 - v1.1.3**

 * new base image [technosoft2000/alpine-base:3.6-2](https://hub.docker.com/r/technosoft2000/alpine-base/)
 * new version allows now usage of group id's __PGID__ < 1000
 * added check of write permissions at `/books` to know if symlinks can be created

**2017-05-28 - v1.1.2**

 * upgrade to __Alpine 3.6__ (new base image [technosoft2000/alpine-base:3.6-1](https://hub.docker.com/r/technosoft2000/alpine-base/))
 * fixed an issue with kindlegen - missing executable in the `vendor` directory
 * added the environment variable `MAGICK_HOME` - defines the ImageMagick home especially for Wand
 * added dependencies `imagemagick-doc` and `imagemagick-dev`

**2017-03-21 - v1.1.1**

 * added creation of gdrive.db symlink at /books/gdrive.db for external access like backup possibility

**2017-03-20 - v1.1.0**

 * added the optional Google Drive integration
 * added creation of app.db symlink at /books/app.db for external access like backup possibility

**2017-03-11 - v1.0.0**

 * calibre-web image is based now on ```technosoft2000/alpine-base:3.5-1.0.0```
 * updated Dockerfile to the latest state needed to run Calibre Web (Latest commit dbf07cb) correctly