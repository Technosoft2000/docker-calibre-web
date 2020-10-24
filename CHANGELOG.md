**2020-10-24 - v1.5.0**

 * new base image [technosoft2000/alpine-base:3.12-1](https://hub.docker.com/r/technosoft2000/alpine-base/) based on Alpine 3.12.0
 * fixed `[WARNING]: Empty continuation line found in: ...` in Dockerfile
 * upgrade of [sgerrand/alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc) to version 2.32-r0
 * changed glibc compiled package (ArchLinux) `libutil-linux` to new `util-linux-libs` - see issue **Build failure in v1.4.1** #87
 * updated dependencies from `requirements.txt` and `optional-requirements.txt` - see issue **Missing jsonschema in the docker image** #90
 * changed python from `python2` to `python3`
 * allow **gevent 20.9.0** otherwise: 
   - error will appear `<frozen importlib._bootstrap>:219: RuntimeWarning: greenlet.greenlet size changed, may indicate binary incompatibility. Expected 144 from C header, got 152 from PyObject`
   - see at `gevent` where the issue was known: https://github.com/gevent/gevent/issues/1260
 * added **unrar**
 * **kepubify** is not added, because Alpine Linux doesn't contains a pre-build package at the moment
 * updated Calibre **ebook-convert** from 4.13.0 to 5.3.0
 * uses `https://github.com/Technosoft2000/docker-calibre-web/releases/download/kindlegen/kindlegen_linux_2.6_i386_v2_9.tar.gz` to download Amazon kindlegen

**2020-04-12 - v1.4.1**

 * new base image [technosoft2000/alpine-base:3.11-2](https://hub.docker.com/r/technosoft2000/alpine-base/) based on Alpine 3.11.5
 * upgrade of [sgerrand/alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc) to version 2.31-r0
 * updated to Calibre 4.13.0
 * added the packages tar xz zstd to unpack needed Arch Linux packages which are compiled with glibc
 * still no upgrade to Python 3 because it doesn't work correct, get the following error:
```
[INFO] Launching Calibre-Web ...
Traceback (most recent call last):
  File "/calibre-web/app/cps.py", line 34, in <module>
    from cps import create_app
  File "/calibre-web/app/cps/__init__.py", line 28, in <module>
    from babel import Locale as LC
ImportError: No module named babel
```
 * maybe I'll switch the base image because Alpine gets to hacky to run Calibre Web correctly, because of the glibc dependencies - see also at https://pythonspeed.com/articles/base-image-python-docker-images/
 * or maybe I'll switch to the linuxserver/calibre-web docker image and discontinue maintanance of this image
 * IMPORTANT regarding update: if you've issues then remove the content from your volume mount -v <your Calibre Web application folder>:/calibre-web/app before you start the container

**2020-01-05 - v1.4.0**

 * new base image [technosoft2000/alpine-base:3.11-1](https://hub.docker.com/r/technosoft2000/alpine-base/) based on Alpine 3.11.2
 * will be upgraded in near future to Python 3
 * still uses Calibre version 3.48.0 to keep working ebook-convert - see at [calibre-web/issues/1056](https://github.com/janeczku/calibre-web/issues/1056)

**2019-12-20 - v1.3.3**

 * upgrade of [sgerrand/alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc) to version 2.30-r0
 * uses Calibre version 3.48.0 to keep working ebook-convert - see at [calibre-web/issues/1056](https://github.com/janeczku/calibre-web/issues/1056)
 * Added [libutil-linux](https://www.archlinux.org/packages/core/x86_64/libutil-linux/) glibc package from Arch Linux to fix issue #52
 * Updated Libraries

| **Program library** | **Installed Version** |
| ------------------- | --------------------- |
| Program library     | Installed             |
| Flask_SimpleLDAP    | Installed             |
| Sqlite	            | v3.28.0               |
| Sqlalchemy	        | v1.3.12               |
| Requests	          | v2.22.0               |
| Iso 639	            | v0.4.6                |
| Flask	              | v1.1.1                |
| Babel	              | v2.7.0                |
| Flask Login	        | v0.4.1                |
| Unidecode           | Installed             |
| Flask Principal	    | v0.4.0                |
| WebServer Gevent	  | v1.4.0                |
| pytz                | 2019.3                |
| Jinja2              | v2.10.3               |
| Werkzeug	          | v0.16.0               |
| Python	            | 2.7.16 (default, May 6 2019, 19:35:26) [GCC 8.3.0] |
| pySqlite	          | v2.6.0                |
| Goodreads           | Installed but shows (Not installed) |
| lxml	              | v4.4.2.0              |
| Image Magick	      | ImageMagick 6.9.10-69 Q16 x86_64 2019-10-29 https://imagemagick.org |
| Wand Version	      | 0.5.8                 |
| PyPdf	              | v1.26.0               |
| Comic_API	          | Installed but shows (Not installed) |
| Pillow              | v6.2.1                |
| Calibre converter	  | ebook-convert (calibre 3.48.0) |
| kindlegen	          | Amazon kindlegen(Linux) V2.9 build 1028-0897292 |

**2019-04-18 - v1.3.2**

 * upgrade of [sgerrand/alpine-pkg-glibc](https://github.com/sgerrand/alpine-pkg-glibc) to version 2.29-r0
 * merged pull request from @ariesdevil [#56 Add missing lib](https://github.com/Technosoft2000/docker-calibre-web/pull/56)
 * Updated Libraries

| **Program library** | **Installed Version** |
| ------------------- | --------------------- |
| Sqlite	            | v3.26.0               |
| lxml	              | v4.3.3.0              |
| Requests	          | v2.21.0               |
| Image Magick	      | ImageMagick 6.9.10-10 Q16 x86_64 2019-04-18 https://www.imagemagick.org |
| kindlegen	          | Amazon kindlegen(Linux) V2.9 build 1028-0897292 |
| Flask	              | v1.0.2                |
| Babel	              | v2.6.0                |
| pytz                | v2019.1               |
| PyPdf	              | v1.26.0               |
| pySqlite	          | v2.6.0                |
| Iso 639	            | v0.4.5                |
| Python	            | 2.7.15 (default, Jan 24 2019, 16:32:39) [GCC 8.2.0] |
| Sqlalchemy	        | v1.3.3                |
| Jinja2              | v2.10.1               |
| Wand Version	      | 0.5.2                 |
| Calibre converter	  | ebook-convert (calibre 3.40.1) |
| Werkzeug	          | v0.15.2               |
| Gevent	            | v1.4.0                |
| Flask Login	        | v0.4.1                |
| Flask Principal	    | v0.4.0                |

**2019-02-24 - v1.3.1**

 * integrated a self compiled version of Ghostscript 9.26 with actual patches from
   https://github.com/alpinelinux/aports/tree/8e262865b06f0d565f7c1ed0b4d8f43bf18b0d68/main/ghostscript
 * should fix the issue [#789 Uploading PDF results in Calibre Web restarting [Docker]](https://github.com/janeczku/calibre-web/issues/789)
 
**2019-02-17 - v1.3.0**

 * new base image [technosoft2000/alpine-base:3.9-1](https://hub.docker.com/r/technosoft2000/alpine-base/) based on Alpine 3.9
 * Patched for ImageMagick 6 the `policy.xml` with ```<policy domain="coder" rights="read" pattern="PDF" />```
   as described at issue [#789 Uploading PDF results in Calibre Web restarting [Docker]](https://github.com/janeczku/calibre-web/issues/789#issuecomment-462038341)
 * check `policy.xml` with ```docker exec -it calibre-web cat /etc/ImageMagick-6/policy.xml```
 * Updated Libraries
  - Calibre converter	ebook-convert (calibre 3.31.0) => (calibre 3.39.1)

| **Program library** | **Installed Version** |
| ------------------- | --------------------- |
| Sqlite	            | v3.26.0               |
| lxml	              | v4.3.1.0              |
| Requests	          | v2.21.0               |
| Image Magick	      | ImageMagick 6.9.10-10 Q16 x86_64 2019-02-17 https://www.imagemagick.org |
| kindlegen	          | Amazon kindlegen(Linux) V2.9 build 1028-0897292 |
| Flask	              | v1.0.2                |
| Babel	              | v2.6.0                |
| pytz                | v2018.9               |
| PyPdf	              | v1.26.0               |
| pySqlite	          | v2.6.0                |
| Iso 639	            | v0.4.5                |
| Python	            | 2.7.15 (default, Jan 24 2019, 16:32:39) [GCC 8.2.0] |
| Sqlalchemy	        | v1.2.18               |
| Jinja2              | v2.10                 |
| Wand Version	      | 0.5.1                 |
| Calibre converter	  | ebook-convert (calibre 3.39.1) |
| Werkzeug	          | v0.14.1               |
| Gevent	            | v1.4.0                |
| Flask Login	        | v0.4.1                |
| Flask Principal	    | v0.4.0                |

**2018-09-09 - v1.2.3**

 * added missing dependency **libxcomposite** which is needed for PDF related conversions via `ebook-convert`
 * Updated Libraries
  - Calibre converter	ebook-convert (calibre 3.30.0) => (calibre 3.31.0)

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
| Sqlalchemy	        | v1.2.11               |
| Iso 639	            | v0.4.5                |
| Calibre converter	  | ebook-convert (calibre 3.31.0) |
| Requests	          | v2.19.1               |
| Gevent	            | v1.3.6                |
| Flask Login	        | v0.4.1                |
| Flask Principal	    | v0.4.0                |

* `ebook-convert` supports the following target formats: 
  **EPUB, AZW3, MOBI, DOCX, FB2, HTMLZ, LIT, LRF, PDB, PDF, PMLZ, RB, RTF, SNB, TCR, TXT, TXTZ, ZIP**
  see also at https://manual.calibre-ebook.com/generated/en/ebook-convert.html

**2018-08-28 - v1.2.2**

 * glibc locale are generated now for the following definitions: [availaible locale](LOCALE.md).
 * fixed issue **ebook-convert : Error: unsupported locale setting** #34
 * updated README.md with new sections:
   - Configuration of a converter
   - Known issues
   - Container Locale
 * Updated Libraries
  - Sqlalchemy	v1.2.10 => v1.2.11
  - Calibre converter	ebook-convert (calibre 3.29.0) => (calibre 3.30.0)
  - Gevent	v1.3.5 => v1.3.6

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
| Sqlalchemy	        | v1.2.11               |
| Iso 639	            | v0.4.5                |
| Calibre converter	  | ebook-convert (calibre 3.30.0) |
| Gevent	            | v1.3.6                |
| Requests	          | v2.19.1               |
| Flask Login	        | v0.4.1                |
| Flask Principal	    | v0.4.0                |

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