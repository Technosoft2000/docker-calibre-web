FROM technosoft2000/alpine-base:3.9-1
MAINTAINER Technosoft2000 <technosoft2000@gmx.net>
LABEL image.version="1.3.3" \
      image.description="Docker image for Calibre Web, based on docker image of Alpine" \
      image.date="2019-12-20" \
      url.docker="https://hub.docker.com/r/technosoft2000/calibre-web" \
      url.github="https://github.com/Technosoft2000/docker-calibre-web" \
      url.support="https://cytec.us/forum"

# Set basic environment settings
ENV \
    # - VERSION: the docker image version (corresponds to the above LABEL image.version)
    VERSION="1.3.3" \

    # - LANG, LANGUAGE, LC_ALL: language dependent settings (Default: en_US.UTF-8)
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \

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
    PKG_DEV="build-base python-dev openssl-dev libffi-dev libxml2-dev libxslt-dev openldap-dev" \
    PKG_PYTHON="ca-certificates py-pip python py-libxml2 py-libxslt py-lxml libev openldap" \
    # WARNING: Wand supports only ImageMagick 6 at the moment and Alpine delivers already ImageMagick 7
    # PKG_IMAGES="imagemagick imagemagick-doc imagemagick-dev" \
    # need to build ImageMagick 6 from source
    PKG_IMAGES_DEV="curl file fontconfig-dev freetype-dev lcms2-dev \
    libjpeg-turbo-dev libpng-dev libtool libwebp-dev perl-dev tiff-dev xz zlib-dev" \
    PKG_IMAGES="fontconfig freetype lcms2 libjpeg-turbo libltdl libpng \
    libwebp libxml2 tiff zlib" \
    
    # Ghostscript
    PKG_GS_DEV="ghostscript-dev" \
    PKG_GS="ghostscript" \
    # WARNING: The current Ghosscript 9.26 has a bug which results into a SEGMENTATION FAULT at Alpine 3.9
    # and therefore we need to build our own Ghosscript 9.26 from source with additional patches
    # Needed to compile Ghostscript 
    #PKG_GS_DEV="libjpeg-turbo-dev libpng-dev jasper-dev expat-dev \
    #zlib-dev tiff-dev freetype-dev lcms2-dev gtk+3.0-dev \
    #cups-dev libtool jbig2dec-dev openjpeg-dev" \
    #PKG_GS="jasper expat jbig2dec openjpeg" \

    # - MAGICK_HOME: the ImageMagick home especially for Wand
    # see at: http://docs.wand-py.org/en/latest/guide/install.html#explicit-link
    # see at: http://docs.wand-py.org/en/latest/wand/version.html
    # see at: http://e-mats.org/2017/04/imagemagick-magickwand-under-alphine-linux-python-alpine/
    #MAGICK_HOME="/usr"
    PKG_MAGICK_DEV="imagemagick6-dev imagemagick6-c++" \
    PKG_MAGICK="imagemagick6 imagemagick6-libs imagemagick6-doc"

# Install GNU libc (aka glibc)
# https://github.com/sgerrand/alpine-pkg-glibc
COPY LOCALE.md /init/
RUN \

    ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" && \
    ALPINE_GLIBC_PACKAGE_VERSION="2.30-r0" && \
    ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \
    ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" && \

    # create temporary directories
    mkdir -p /tmp && \
    mkdir -p /var/cache/apk && \

    apk add --no-cache --virtual=.build-dependencies wget ca-certificates && \
    apk add --no-cache parallel && \

    wget "https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub" \
         -O "/etc/apk/keys/sgerrand.rsa.pub" && \

    wget "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
         "$ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \

    apk add --no-cache \
        "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
        "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME" && \

    # iterate through all locale and install it
    # NOTE: locale -a is not available in alpine linux, 
    # use `/usr/glibc-compat/bin/locale -a` instead
    cat /init/LOCALE.md | parallel "echo generate locale {}; /usr/glibc-compat/bin/localedef --force --inputfile {} --charmap UTF-8 {}.UTF-8;" && \

    apk del .build-dependencies && \

    rm "/etc/apk/keys/sgerrand.rsa.pub" && \
    rm "/root/.wget-hsts" && \
    rm "$ALPINE_GLIBC_BASE_PACKAGE_FILENAME" \
       "$ALPINE_GLIBC_BIN_PACKAGE_FILENAME" \
       "$ALPINE_GLIBC_I18N_PACKAGE_FILENAME"

RUN wget "https://www.archlinux.org/packages/core/x86_64/libutil-linux/download/" -O /tmp/libutil-linux.tar.xz \
    && mkdir -p /tmp/libutil-linux \
    && tar -xf /tmp/libutil-linux.tar.xz -C /tmp/libutil-linux \
    && cp /tmp/libutil-linux/usr/lib/* /usr/glibc-compat/lib \
    && /usr/glibc-compat/sbin/ldconfig \
    && rm -rf /tmp/libutil-linux /tmp/libutil-linux.tar.xz

# TODO
# /usr/glibc-compat/sbin/ldconfig: /usr/glibc-compat/lib/ld-linux-x86-64.so.2 is not a symbolic link
# /usr/glibc-compat/sbin/ldconfig: /usr/glibc-compat/lib/libsmartcols.so.1 is not a symbolic link
# /usr/glibc-compat/sbin/ldconfig: /usr/glibc-compat/lib/libmount.so.1 is not a symbolic link
# /usr/glibc-compat/sbin/ldconfig: /usr/glibc-compat/lib/libuuid.so.1 is not a symbolic link
# /usr/glibc-compat/sbin/ldconfig: /usr/glibc-compat/lib/libblkid.so.1 is not a symbolic link
# /usr/glibc-compat/sbin/ldconfig: /usr/glibc-compat/lib/libfdisk.so.1 is not a symbolic link

# Copy the necessary Ghostscript 9.26 patches
#COPY ghostscript /init/ghostscript/

# TODO
# ERROR: comicapi 2.0 has requirement natsort==3.5.2, but you'll have natsort 6.2.0 which is incompatible.
RUN \
    echo "--- Update the package list ------------------------------------------------" && \
    apk -U upgrade && \

    echo "--- Install applications via package manager -------------------------------" && \
    apk -U add --no-cache $PKG_DEV $PKG_PYTHON $PKG_IMAGES_DEV $PKG_IMAGES $PKG_GS_DEV $PKG_GS $PKG_MAGICK_DEV $PKG_MAGICK && \

    echo "--- Upgrade pip to the latest version --------------------------------------" && \
    pip install --upgrade pip && \

    echo "--- Install python packages via pip ----------------------------------------" && \
    pip --no-cache-dir install --upgrade \
        setuptools \
        pyopenssl \
    ### REQUIRED ###
    ### see https://github.com/janeczku/calibre-web/blob/master/requirements.txt
        'Babel>=1.3' \
        'Flask-Babel>=0.11.1' \
        'Flask-Login>=0.3.2' \
        'Flask-Principal>=0.3.2' \
        'singledispatch>=3.4.0.0' \
        'backports_abc>=0.4' \
        'Flask>=1.0.2' \
        'iso-639>=0.4.5' \
        'PyPDF2==1.26.0' \
        'pytz>=2016.10' \
        'requests>=2.11.1' \
        'SQLAlchemy>=1.1.0' \
        'tornado>=4.1' \
        'Wand>=0.4.4' \
        'unidecode>=0.04.19' \
    ### OPTIONAL ###
    ### https://github.com/janeczku/calibre-web/blob/master/optional-requirements.txt
        # GDrive Integration
        'google-api-python-client==1.7.11' \
        'gevent>=1.2.1' \
        'greenlet>=0.4.12' \
        'httplib2>=0.9.2' \
        'oauth2client>=4.0.0' \
        'uritemplate>=3.0.0' \
        'pyasn1-modules>=0.0.8' \
        'pyasn1>=0.1.9' \
        'PyDrive>=1.3.1' \
        'PyYAML>=3.12' \
        'rsa==3.4.2' \
        'six==1.10.0' \
        # goodreads
        'goodreads>=0.3.2' \
        'python-Levenshtein>=0.12.0' \
        # ldap login
        'python_ldap>=3.0.0' \
        'flask-simpleldap>1.3.0' \
        #oauth
        'flask-dance>=0.13.0' \
        'sqlalchemy_utils>=0.33.5' \
        # extracting metadata
        'lxml>=3.8.0' \
        'Pillow>=4.0.0' \
        'rarfile>=2.7' \
        # other
        'natsort>=2.2.0' \
        'git+https://github.com/OzzieIsaacs/comicapi.git@5346716578b2843f54d522f44d01bc8d25001d24#egg=comicapi' \
    && \

    ### Ghostscript ###
    #echo "--- Get Ghostscript 9.26 and build it --------------------------------------" && \

    # create temporary build directory for Ghostscript
    #mkdir -p /tmp/ghostscript && \

    # download Ghostscript
    #curl -o /tmp/ghostscript-src.tar.gz -L "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs926/ghostscript-9.26.tar.gz" && \

    # unpack Ghostscript
    #tar xf /tmp/ghostscript-src.tar.gz -C /tmp/ghostscript --strip-components=1 && \

    # patch & configure Ghostscript
    #cp /init/ghostscript/* /tmp/ghostscript && \
    #cd /tmp/ghostscript && \
    #patch cups/gdevcups.c fix-sprintf.patch && \
    #patch base/gdevsclass.c fix-put_image-methode.patch && \
    #patch base/stdio_.h fix-stdio.patch && \
    #patch base/lib.mak ghostscript-system-zlib.patch && \
    #./configure && \

    # compile Ghostscript
    #make so all && \

    # install Ghostscript
    #make soinstall && \
    #make install && \

    ### ImageMagic ###
    #echo "--- Get ImageMagic 6 and build it ------------------------------------------" && \
    #IMAGEMAGICK_VER=$(curl --silent http://www.imagemagick.org/download/digest.rdf \
	  # | grep ImageMagick-6.*tar.xz | sed 's/\(.*\).tar.*/\1/' | sed 's/^.*ImageMagick-/ImageMagick-/') && \

    # create temporary build directory for ImageMagic
    #mkdir -p /tmp/imagemagick && \

    # download ImageMagic
    #curl -o /tmp/imagemagick-src.tar.xz -L "http://www.imagemagick.org/download/${IMAGEMAGICK_VER}.tar.xz" && \

    # unpack ImageMagic
    #tar xf /tmp/imagemagick-src.tar.xz -C /tmp/imagemagick --strip-components=1 && \

    # configure ImageMagic
    #cd /tmp/imagemagick && \

    #sed -i -e \
	  #'s:DOCUMENTATION_PATH="${DATA_DIR}/doc/${DOCUMENTATION_RELATIVE_PATH}":DOCUMENTATION_PATH="/usr/share/doc/imagemagick":g' \
	  #configure && \

    #./configure \
	  #--infodir=/usr/share/info \
	  #--mandir=/usr/share/man \
	  #--prefix=/usr \
	  #--sysconfdir=/etc \
	  #--with-gs-font-dir=/usr/share/fonts/Type1 \
	  #--with-gslib \
	  #--with-lcms2 \
	  #--with-modules \
	  #--without-threads \
	  #--without-x \
	  #--with-tiff \
	  #--with-xml && \

    # compile ImageMagic
    #make && \

    # install ImageMagic
    #make install && \
    #find / -name '.packlist' -o -name 'perllocal.pod' -o -name '*.bs' -delete && \

    # cleanup temporary files
    rm -rf /tmp/* 

# Install calibre binary
# enhancement from jim3ma/docker-calibre-web
# needed for calibre ebook-convert command line tool
# https://github.com/jim3ma/docker-calibre-web
# https://manual.calibre-ebook.com/generated/en/ebook-convert.html
ENV \
    LD_LIBRARY_PATH="/usr/lib:/opt/calibre/lib" \
    PATH="$PATH:/opt/calibre" \
    LC_ALL="C" \
    CALIBRE_INSTALLER_SOURCE_CODE_URL="https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py"

RUN \
    apk update && \
    apk add --no-cache --upgrade \
        bash \
        ca-certificates \
        gcc \
        libxcomposite \
        mesa-gl \
        python \
        qt5-qtbase-x11 \
        xdg-utils \
        xz \
        wget && \

    # download Calibre version 3.48.0
    wget -O- ${CALIBRE_INSTALLER_SOURCE_CODE_URL} | \
      python -c \
      "import sys; \
       main=lambda:sys.stderr.write('Download failed\n'); \
       exec(sys.stdin.read()); \
       main(install_dir='/opt', isolated=True, version='3.48.0')" && \

    rm -rf /tmp/calibre-installer-cache && \

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

# copy patched version of ImageMagick policy.xml
COPY imagemagick/policy.xml /etc/ImageMagick-6

# Set volumes for the Calibre Web folder structure
VOLUME /books
VOLUME $APP_HOME/app
VOLUME $APP_HOME/config
VOLUME $APP_HOME/kindlegen

# Expose ports
EXPOSE 8083
