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

 * new base image [technosoft2000/alpine-base:3.6-2](https://hub.docker.com/r/technosoft2000/alpine-base/))
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