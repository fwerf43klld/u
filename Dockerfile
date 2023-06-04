################################################################################
# base system
################################################################################

FROM ubuntu:22.04 as system

# Avoid prompts for time zone
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Paris
# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1

# built-in packages
# RUN apt-get update && apt-get upgrade -y && apt-get install apt-utils -y \
#     && apt-get install -y software-properties-common curl apache2-utils \
#     && apt-get update \
#     && apt-get install -y \
#         supervisor nginx sudo net-tools zenity \
#         dbus-x11 x11-utils alsa-utils \
#         mesa-utils wget

# # install debs error if combine together
# RUN apt-get update \
#     && apt-get install -y \
#         xvfb x11vnc \
#         vim-tiny ttf-wqy-zenhei

# RUN apt-get update \
#     && apt-get install -y \
#         lxde gtk2-engines-murrine gnome-themes-standard arc-theme


# RUN apt-get update && apt-get install -y python3 python3-tk gcc make cmake

# # tini to fix subreap
# ARG TINI_VERSION=v0.19.0
# RUN wget https://github.com/krallin/tini/archive/v0.19.0.tar.gz \
#  && tar zxf v0.19.0.tar.gz \
#  && export CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"; \
#     cd tini-0.19.0; cmake . && make && make install \
#  && cd ..; rm -r tini-0.19.0 v0.19.0.tar.gz


# # NextCloud
# RUN apt-get update && apt-get install -y nextcloud-desktop

# # Firefox with apt, not snap (which does not run in the container)
# COPY mozilla-firefox_aptprefs.txt /etc/apt/preferences.d/mozilla-firefox
# RUN add-apt-repository -y ppa:mozillateam/ppa
# RUN apt-get update && apt-get install -y --allow-downgrades firefox fonts-lyx

# # Chromium beta with apt, not snap (which does not run in the container)
# COPY chromium_aptprefs.txt /etc/apt/preferences.d/chromium
# RUN sudo add-apt-repository -y ppa:saiarcot895/chromium-beta
# RUN  apt-get update && apt-get install -y --allow-downgrades chromium-browser
# RUN sed -i 's/Exec=chromium-browser %U/Exec=chromium-browser %U --no-sandbox/g' /usr/share/applications/chromium-browser.desktop


# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \
#         # This is necessary for apt to access HTTPS sources:
#         apt-transport-https \
#         gnupg-agent \
#         gpg-agent \
#         gnupg2 \
#         ca-certificates \
#         build-essential \
#         pkg-config \
#         software-properties-common \
#         lsof \
#         net-tools \
#         libcurl4 \
#         curl \
#         wget \
#         cron \
#         openssl \
#         iproute2 \
#         psmisc \
#         tmux \
#         dpkg-sig \
#         uuid-dev \
#         csh \
#         xclip \
#         clinfo \
#         time \
#         libssl-dev \
#         libgdbm-dev \
#         libncurses5-dev \
#         libncursesw5-dev \
#         # required by pyenv
#         libreadline-dev \
#         libedit-dev \
#         xz-utils \
#         gawk \
#         # Simplified Wrapper and Interface Generator (5.8MB) - required by lots of py-libs
#         swig \
#         # Graphviz (graph visualization software) (4MB)
#         graphviz libgraphviz-dev \
#         # Terminal multiplexer
#         screen \
#         # Editor
#         nano \
#         openvpn 
#        
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \      
#     	 # Find files
#     	locate \
#         # Dev Tools
#         sqlite3 \
#         # XML Utils
#         xmlstarlet 
	
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \  
#         # GNU parallel
#         parallel \
#         #  R*-tree implementation - Required for earthpy, geoviews (3MB)
#         libspatialindex-dev \
#         # Search text and binary files
#         yara \
#         # Minimalistic C client for Redis
#         libhiredis-dev \
#         # postgresql client
#         libpq-dev \
#         # mysql client (10MB)
#         libmysqlclient-dev \
#         # mariadb client (7MB)
#         # libmariadbclient-dev \
#         # image processing library (6MB), required for tesseract
#         libleptonica-dev \
#         # GEOS library (3MB)
#         libgeos-dev 
        
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \  
#     # style sheet preprocessor
#         less \
#         # Print dir tree
#         tree \
#         # Bash autocompletion functionality
#         bash-completion \
#         # ping support
#         iputils-ping \
#         # Map remote ports to localhosM
#         socat \
#         # Json Processor
#         jq \
#         rsync \
#         # sqlite3 driver - required for pyenv
#         libsqlite3-dev 
	
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \  
#         # VCS:
#         subversion \
#         jed \
#         # odbc drivers
#         unixodbc unixodbc-dev \
#         # Image support
#         libtiff-dev \
#         libjpeg-dev \
#         libpng-dev \
#         libglib2.0-0 \
#         libxext6 \
#         libsm6 \
#         libxext-dev \
#         libxrender1 \
#         libzmq3-dev \
#         # protobuffer support
#         protobuf-compiler \
#         libprotobuf-dev \
#         libprotoc-dev \
#         autoconf \
#         automake \
#         libtool 
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \  
#         cmake  \
#         fonts-liberation \
#         google-perftools 
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \  
#         # Compression Libs
#         # also install rar/unrar? but both are propriatory or unar (40MB)
#         zip \
#         gzip \
#         unzip \
#         bzip2 \
#         lzop 
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \  
# 	# deprecates bsdtar (https://ubuntu.pkgs.org/20.04/ubuntu-universe-i386/libarchive-tools_3.4.0-2ubuntu1_i386.deb.html)
#         libarchive-tools 
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \  
#         zlib1g \
# 	zlib1g-dev 
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \
#         # unpack (almost) everything with one command
#         unp
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \
#         libbz2-dev \
#         liblzma-dev \
#         zlib1g-dev 
	
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \   
#     git
    
# RUN apt-get update --fix-missing && \
#     apt-get install -y apt-utils && \
#     apt-get upgrade -y && \
#     apt-get update && \
#     apt-get install -y --no-install-recommends \   
#     snapd &&\
#     ln -s /var/lib/snapd/snap /snap 
 
#RUN snap install telegram-desktop 

RUN LC_ALL=en_US.UTF-8 
RUN apt-get update -qq \
    && apt-get install -y -qq software-properties-common python3-software-properties \
    && apt-add-repository ppa:remmina-ppa-team/remmina-next-daily -y \
    && apt-add-repository ppa:alexlarsson/flatpak -y \
    && apt-get update -qq 
    
RUN apt-get update -qq \
    && apt install -y -qq flatpak-builder flatpak build-essential git-core \
    cmake curl freerdp2-dev intltool libappindicator3-dev libasound2-dev \
    libavahi-ui-gtk3-dev libavcodec-dev libavresample-dev libavutil-dev \
    libcups2-dev libgcrypt20-dev libgnutls28-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev libgtk-3-dev \
    libjpeg-dev libjson-glib-dev libpcre2-8-0 libpcre2-dev libpulse-dev \
    libsecret-1-dev libsodium-dev libsoup2.4-dev libspice-client-gtk-3.0-dev \
    libspice-protocol-dev libssh-dev libssl-dev libsystemd-dev \
    libtelepathy-glib-dev libvncserver-dev libvte-2.91-dev libwebkit2gtk-4.0-dev \
    libx11-dev libxcursor-dev libxdamage-dev libxext-dev libxi-dev \
    libxinerama-dev libxkbfile-dev libxkbfile-dev libxml2 libxml2-dev \
    libxrandr-dev libxtst-dev libxv-dev python3 python3-dev wget
	
# Killsession app
COPY killsession/ /tmp/killsession
RUN cd /tmp/killsession; \
    gcc -o killsession killsession.c && \
    mv killsession /usr/local/bin && \
    chmod a=rx /usr/local/bin/killsession && \
    chmod a+s /usr/local/bin/killsession && \
    mv killsession.py /usr/local/bin/ && chmod a+x /usr/local/bin/killsession.py && \
    mkdir -p /usr/local/share/pixmaps && mv killsession.png /usr/local/share/pixmaps/ && \
    mv KillSession.desktop /usr/share/applications/ && chmod a+x /usr/share/applications/KillSession.desktop && \
    cd /tmp && rm -r killsession
    

# python library
COPY rootfs/usr/local/lib/web/backend/requirements.txt /tmp/
RUN apt-get update \
    && dpkg-query -W -f='${Package}\n' > /tmp/a.txt \
    && apt-get install -y python3-pip python3-dev build-essential \
    && pip3 install -r /tmp/requirements.txt \
    && ln -s /usr/bin/python3 /usr/local/bin/python \
    && dpkg-query -W -f='${Package}\n' > /tmp/b.txt \
    && apt-get remove -y `diff --changed-group-format='%>' --unchanged-group-format='' /tmp/a.txt /tmp/b.txt | xargs` \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* /tmp/a.txt /tmp/b.txt


################################################################################
# builder
################################################################################
FROM ubuntu:22.04 as builder

RUN apt-get update \
    && apt-get install -y curl ca-certificates gnupg

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -fs https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/yarnpkg_pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

# build frontend
COPY web /src/web
RUN cd /src/web \
    && yarn upgrade \
    && yarn \
    && yarn build
RUN sed -i 's#app/locale/#novnc/app/locale/#' /src/web/dist/static/novnc/app/ui.js

RUN apt autoremove && apt autoclean

################################################################################
# merge
################################################################################
FROM system
LABEL maintainer="frederic.boulanger@centralesupelec.fr"

COPY --from=builder /src/web/dist/ /usr/local/lib/web/frontend/
COPY rootfs /
RUN ln -sf /usr/local/lib/web/frontend/static/websockify /usr/local/lib/web/frontend/static/novnc/utils/websockify && \
	chmod +x /usr/local/lib/web/frontend/static/websockify/run

EXPOSE 80
WORKDIR /root
ENV HOME=/home/ubuntu \
    SHELL=/bin/bash
HEALTHCHECK --interval=30s --timeout=5s CMD curl --fail http://127.0.0.1:6079/api/health
ENTRYPOINT ["/startup.sh"]
