FROM alpine:3.4
MAINTAINER Technosoft2000 <technosoft2000@gmx.net> 

# Set basic environment settings

ENV \
    # - TERM: The name of a terminal information file from /lib/terminfo, 
    # this file instructs terminal programs how to achieve things such as displaying color.
    TERM="xterm" \

    # - LANG, LANGUAGE, LC_ALL: language dependent settings (Default: de_DE.UTF-8)
    LANG="de_DE.UTF-8" \
    LANGUAGE="de_DE:de" \
    LC_ALL="de_DE.UTF-8" \

    # - PKG_*: the needed applications for installation
    GOSU_VERSION="1.9" \
    PKG_BASE="bash tzdata git" \
    PKG_DEV="make gcc g++ python-dev openssl-dev libffi-dev" \
    PKG_PYTHON="ca-certificates py-pip python py-libxml2 py-lxml" \
    PKG_IMAGES="imagemagick" \
    
    # - SET_CONTAINER_TIMEZONE: set this environment variable to true to set timezone on container startup
    SET_CONTAINER_TIMEZONE="false" \

    # - CONTAINER_TIMEZONE: UTC, Default container timezone as found under the directory /usr/share/zoneinfo/
    CONTAINER_TIMEZONE="UTC" \

    # - CW_HOME: Calibre Web Home directory
    CW_HOME="/calibre-web" \

    # - CW_REPO, CW_BRANCH: Calibre Web GitHub repository and related branch
    CW_REPO="https://github.com/janeczku/calibre-web.git" \
    CW_BRANCH="master" \

    # - AMAZON_KINDLEGEN: KindleGen is a command line tool which enables publishers to work 
    #   in an automated environment with a variety of source content including HTML, XHTML or EPUB
    AMAZON_KG_TAR="kindlegen_linux_2.6_i386_v2_9.tar.gz" \
    AMAZON_KG_URL="http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz" \

    # - SYNO_VOLUME: Snyology NAS volume main directory
    SYNO_VOLUME="/volume1" \

    # - CALIBRE_PATH: Configure the path where the Calibre database is located
    CALIBRE_PATH="/volume1/books"
	
RUN \
    # update the package list
    apk -U upgrade && \

    # install gosu from https://github.com/tianon/gosu
    set -x \
    && apk add --no-cache --virtual .gosu-deps \
        dpkg \
        gnupg \
        openssl \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apk del .gosu-deps \
    && \

    # install the needed applications
    apk -U add --no-cache $PKG_BASE $PKG_DEV $PKG_PYTHON $PKG_IMAGES && \

    # install additional python packages:
    # setuptools, pyopenssl, gunicorn, wand 
    pip --no-cache-dir install --upgrade setuptools && \
    pip --no-cache-dir install --upgrade pyopenssl gunicorn wand && \

    # remove not needed packages
    apk del $PKG_DEV && \

    # create Snyology NAS /volume1 folders 
    # to easily provide the same corresponding host directories at Calibre Web
    mkdir -p $SYNO_VOLUME/books && \
    mkdir -p $SYNO_VOLUME/certificates && \

    # create Calibre Web folder structure
    mkdir -p $CW_HOME/app && \

    # download and install KindleGen
    mkdir -p $CW_HOME/kindlegen && \
    wget $AMAZON_KG_URL -P /tmp && \
    tar -xzf /tmp/$AMAZON_KG_TAR -C $CW_HOME/kindlegen && \

    # cleanup temporary files
    rm -rf /tmp && \
    rm -rf /var/cache/apk/*

# set the working directory for Calibre Web
WORKDIR $CW_HOME/app

#start.sh will download the latest version of Calibre Web and run it.
COPY *.txt $CW_HOME/
COPY *.sh $CW_HOME/
RUN chmod u+x $CW_HOME/start.sh

# Set volumes for the Calibre Web folder structure
VOLUME $SYNO_VOLUME/books $SYNO_VOLUME/certificates

# Expose ports
EXPOSE 8083

# Start Calibre Web
CMD ["/bin/bash", "-c", "$CW_HOME/start.sh"]
