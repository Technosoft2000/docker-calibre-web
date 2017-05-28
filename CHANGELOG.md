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