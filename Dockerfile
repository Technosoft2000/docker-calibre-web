FROM technosoft2000/alpine-base:3.6-3
MAINTAINER Technosoft2000 <technosoft2000@gmx.net>
LABEL image.version="1.1.11" \
      image.description="Docker image for Calibre Web, based on docker image of Alpine" \
      image.date="2018-04-14" \
      url.docker="https://hub.docker.com/r/technosoft2000/calibre-web" \
      url.github="https://github.com/Technosoft2000/docker-calibre-web" \
      url.support="https://cytec.us/forum"

# Set basic environment settings
ENV \
    # - VERSION: the docker image version (corresponds to the above LABEL image.version)
    VERSION="1.1.11" \
    
    # - PUSER, PGROUP: the APP user and group name
    PUSER="calibre" \
	PGROUP="calibre" \

    # - APP_NAME: the APP name
    APP_NAME="Calibre-Web" \

    # - APP_HOME: the APP home directory
    APP_HOME="/calibre-web" \

    # - APP_REPO, APP_BRANCH: the APP GitHub repository and related branch
    # for related branch or tag use e.g. master
    APP_REPO="https://github.com/janeczku/calibre-web.git" \
    APP_BRANCH="master" \

    # - AMAZON_KG_*: KindleGen is a command line tool which enables publishers to work 
    # in an automated environment with a variety of source content including HTML, XHTML or EPUB
    AMAZON_KG_TAR="kindlegen_linux_2.6_i386_v2_9.tar.gz" \
    AMAZON_KG_URL="http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz" \

    # - CALIBRE_PATH: Configure the path where the Calibre database is located
    CALIBRE_PATH="/books" \
	
    # - PKG_*: the needed applications for installation
    PKG_DEV="make gcc g++ python-dev openssl-dev libffi-dev libxml2-dev libxslt-dev" \
    PKG_PYTHON="ca-certificates py-pip python py-libxml2 py-libxslt py-lxml libev" \
    # WARNING: Wand supports only ImageMagick 6 at the moment and Alpine delivers already ImageMagick 7
    # PKG_IMAGES="imagemagick imagemagick-doc imagemagick-dev" \
    # need to build ImageMagick 6 from source
    PKG_IMAGES_DEV="curl file fontconfig-dev freetype-dev ghostscript-dev lcms2-dev \
    libjpeg-turbo-dev libpng-dev libtool libwebp-dev perl-dev tiff-dev xz zlib-dev" \
    PKG_IMAGES="fontconfig freetype ghostscript lcms2 libjpeg-turbo libltdl libpng \
	libwebp libxml2 tiff zlib" \

    # - MAGICK_HOME: the ImageMagick home especially for Wand
    # see at: http://docs.wand-py.org/en/latest/guide/install.html#explicit-link
    # see at: http://docs.wand-py.org/en/latest/wand/version.html
    # see at: http://e-mats.org/2017/04/imagemagick-magickwand-under-alphine-linux-python-alpine/
    MAGICK_HOME="/usr"

RUN \
    # create temporary directories
    mkdir -p /tmp && \
    mkdir -p /var/cache/apk && \

    # update the package list
    apk -U upgrade && \

    # install the needed applications
    apk -U add --no-cache $PKG_DEV $PKG_PYTHON $PKG_IMAGES_DEV $PKG_IMAGES && \

    # install additional python packages:
    ### REQUIRED ###
    ### see https://github.com/janeczku/calibre-web/blob/master/requirements.txt
    pip --no-cache-dir install --upgrade \
      pip setuptools \
      pyopenssl Babel \
      Flask Flask-Babel Flask-Login Flask-Principal \
      iso-639 PyPDF2 pytz requests \
      SQLAlchemy tornado Wand unidecode \
    ### OPTIONAL ###
    ### https://github.com/janeczku/calibre-web/blob/master/optional-requirements.txt
      gevent google-api-python-client greenlet \
      httplib2 lxml oauth2client \
      pyasn1-modules pyasn1 pydrive pyyaml \
      rsa six uritemplate goodreads python-Levenshtein\
      && \

    # get actual ImageMagic 6 version info
    IMAGEMAGICK_VER=$(curl --silent http://www.imagemagick.org/download/digest.rdf \
	| grep ImageMagick-6.*tar.xz | sed 's/\(.*\).tar.*/\1/' | sed 's/^.*ImageMagick-/ImageMagick-/') && \

    # create temporary build directory for ImageMagic
    mkdir -p /tmp/imagemagick && \

    # download ImageMagic
    curl -o /tmp/imagemagick-src.tar.xz -L "http://www.imagemagick.org/download/${IMAGEMAGICK_VER}.tar.xz" && \

    # unpack ImageMagic
    tar xf /tmp/imagemagick-src.tar.xz -C /tmp/imagemagick --strip-components=1 && \

    # configure ImageMagic
    cd /tmp/imagemagick && \

    sed -i -e \
	's:DOCUMENTATION_PATH="${DATA_DIR}/doc/${DOCUMENTATION_RELATIVE_PATH}":DOCUMENTATION_PATH="/usr/share/doc/imagemagick":g' \
	configure && \

    ./configure \
	  --infodir=/usr/share/info \
	  --mandir=/usr/share/man \
	  --prefix=/usr \
	  --sysconfdir=/etc \
	  --with-gs-font-dir=/usr/share/fonts/Type1 \
	  --with-gslib \
	  --with-lcms2 \
	  --with-modules \
	  --without-threads \
	  --without-x \
	  --with-tiff \
	  --with-xml && \

    # compile ImageMagic
    make && \

    # install ImageMagic
    make install && \
    find / -name '.packlist' -o -name 'perllocal.pod' -o -name '*.bs' -delete && \

    # remove not needed packages
    apk del --purge $PKG_DEV \
                    $PKG_IMAGES_DEV && \

    # create Calibre Web folder structure
    mkdir -p $APP_HOME/app && \

    # cleanup temporary files
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*

# set the working directory for the APP
WORKDIR $APP_HOME/app

# copy files to the image (info.txt and scripts)
COPY *.txt /init/
COPY *.sh /init/

# copy Calibre related files (e.g. metadata.db)
COPY calibre-init /init/calibre-init

# Set volumes for the Calibre Web folder structure
VOLUME /books
VOLUME $APP_HOME/app
VOLUME $APP_HOME/config
VOLUME $APP_HOME/kindlegen

# Expose ports
EXPOSE 8083
