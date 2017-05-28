FROM technosoft2000/alpine-base:3.6-1
MAINTAINER Technosoft2000 <technosoft2000@gmx.net>
LABEL image.version="1.1.2" \
      image.description="Docker image for Calibre Web, based on docker image of Alpine" \
      image.date="2017-05-28" \
      url.docker="https://hub.docker.com/r/technosoft2000/calibre-web" \
      url.github="https://github.com/Technosoft2000/docker-calibre-web" \
      url.support="https://cytec.us/forum"

# Set basic environment settings
ENV \
    # - VERSION: the docker image version (corresponds to the above LABEL image.version)
    VERSION="1.1.2" \
    
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
    PKG_IMAGES="imagemagick"

RUN \
    # create temporary directories
    mkdir -p /tmp && \
    mkdir -p /var/cache/apk && \

    # update the package list
    apk -U upgrade && \

    # install the needed applications
    apk -U add --no-cache $PKG_DEV $PKG_PYTHON $PKG_IMAGES && \

    # install additional python packages:
    ### REQUIRED ###
    pip --no-cache-dir install --upgrade pip && \
    pip --no-cache-dir install --upgrade setuptools && \
    pip --no-cache-dir install --upgrade pyopenssl babel && \
    pip --no-cache-dir install --upgrade flask flask-babel flask-login flask-principal && \
    pip --no-cache-dir install --upgrade iso-639 pypdf2 pytz requests && \
    pip --no-cache-dir install --upgrade sqlalchemy tornado wand && \
    ### OPTIONAL ###
    pip --no-cache-dir install --upgrade gevent google-api-python-client greenlet && \
    pip --no-cache-dir install --upgrade httplib2 lxml oauth2client && \
    pip --no-cache-dir install --upgrade pyasn1-modules pyasn1 pydrive pyyaml && \
    pip --no-cache-dir install --upgrade rsa six uritemplate && \

    # remove not needed packages
    apk del $PKG_DEV && \

    # create Calibre Web folder structure
    mkdir -p $APP_HOME/app && \

    # download and install KindleGen
    mkdir -p $APP_HOME/kindlegen && \
    wget $AMAZON_KG_URL -P /tmp && \
    tar -xzf /tmp/$AMAZON_KG_TAR -C $APP_HOME/kindlegen && \

    # cleanup temporary files
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*

# set the working directory for the APP
WORKDIR $APP_HOME/app

# copy files to the image (info.txt and scripts)
COPY *.txt /init/
COPY *.sh /init/

# Set volumes for the Calibre Web folder structure
VOLUME /books

# Expose ports
EXPOSE 8083
