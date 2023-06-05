################################################################################
# base system
################################################################################
FROM ubuntu:22.04 as system


# Set noninteractive
ENV DEBIAN_FRONTEND noninteractive
# # Avoid prompts for time zone
# ENV DEBIAN_FRONTEND noninteractive
ENV TZ=Europe/Paris
# Fix issue with libGL on Windows
ENV LIBGL_ALWAYS_INDIRECT=1

# Layer cleanup script
COPY resources/scripts/clean-layer.sh  /usr/bin/clean-layer.sh
COPY resources/scripts/fix-permissions.sh  /usr/bin/fix-permissions.sh

ENV \
    SHELL="/bin/bash" \
    HOME="/root"  \
    # Nobteook server user: https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile#L33
    NB_USER="root" \
    USER_GID=0 \
    XDG_CACHE_HOME="/root/.cache/" \
    XDG_RUNTIME_DIR="/tmp" \
    DISPLAY=":1" \
    TERM="xterm" \
    DEBIAN_FRONTEND="noninteractive" \
    RESOURCES_PATH="/resources" \
    SSL_RESOURCES_PATH="/resources/ssl" \
    WORKSPACE_HOME="/workspace"
    
WORKDIR /root
 # Make clean-layer and fix-permissions executable
RUN \
    chmod a+rwx /usr/bin/clean-layer.sh && \
    chmod a+rwx /usr/bin/fix-permissions.sh
    
RUN apt-get update -qq \
    && apt-get install -y -qq software-properties-common python3-software-properties \
    && apt-add-repository ppa:remmina-ppa-team/remmina-next-daily -y \
    && apt-get update -qq \
    && apt install -y -qq build-essential git-core \
    cmake curl freerdp2-dev intltool remmina remmina-plugin-rdp wget \
    && apt-get autoremove -y \
    && apt-get clean -y
    
# FROM ubuntu:22.04 as system



# built-in packages
RUN apt-get update && apt-get upgrade -y && apt-get install apt-utils -y \
    && apt-get install -y software-properties-common curl apache2-utils \
    && apt-get update \
    && apt-get install -y \
        supervisor nginx sudo net-tools zenity \
        dbus-x11 x11-utils alsa-utils \
        mesa-utils wget

# install debs error if combine together
RUN apt-get update \
    && apt-get install -y \
        xvfb x11vnc \
        vim-tiny ttf-wqy-zenhei

RUN apt-get update \
    && apt-get install -y \
        lxde gtk2-engines-murrine gnome-themes-standard arc-theme


RUN apt-get update && apt-get install -y python3 python3-tk gcc make cmake

# tini to fix subreap
ARG TINI_VERSION=v0.19.0
RUN wget https://github.com/krallin/tini/archive/v0.19.0.tar.gz \
 && tar zxf v0.19.0.tar.gz \
 && export CFLAGS="-DPR_SET_CHILD_SUBREAPER=36 -DPR_GET_CHILD_SUBREAPER=37"; \
    cd tini-0.19.0; cmake . && make && make install \
 && cd ..; rm -r tini-0.19.0 v0.19.0.tar.gz


# NextCloud
RUN apt-get update && apt-get install -y nextcloud-desktop

# Firefox with apt, not snap (which does not run in the container)
COPY mozilla-firefox_aptprefs.txt /etc/apt/preferences.d/mozilla-firefox
RUN add-apt-repository -y ppa:mozillateam/ppa
RUN apt-get update && apt-get install -y --allow-downgrades firefox fonts-lyx

# Chromium beta with apt, not snap (which does not run in the container)
COPY chromium_aptprefs.txt /etc/apt/preferences.d/chromium
RUN sudo add-apt-repository -y ppa:saiarcot895/chromium-beta
RUN  apt-get update && apt-get install -y --allow-downgrades chromium-browser
RUN sed -i 's/Exec=chromium-browser %U/Exec=chromium-browser %U --no-sandbox/g' /usr/share/applications/chromium-browser.desktop


RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        # This is necessary for apt to access HTTPS sources:
        apt-transport-https \
        gnupg-agent \
        gpg-agent \
        gnupg2 \
        ca-certificates \
        build-essential \
        pkg-config \
        software-properties-common \
        lsof \
        net-tools \
        libcurl4 \
        curl \
        wget \
        cron \
        openssl \
        iproute2 \
        psmisc \
        tmux \
        dpkg-sig \
        uuid-dev \
        csh \
        xclip \
        clinfo \
        time \
        libssl-dev \
        libgdbm-dev \
        libncurses5-dev \
        libncursesw5-dev \
        # required by pyenv
        libreadline-dev \
        libedit-dev \
        xz-utils \
        gawk \
        # Simplified Wrapper and Interface Generator (5.8MB) - required by lots of py-libs
        swig \
        # Graphviz (graph visualization software) (4MB)
        graphviz libgraphviz-dev \
        # Terminal multiplexer
        screen \
        # Editor
        nano \
        openvpn 


       
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \      
    	 # Find files
    	locate \
        # Dev Tools
        sqlite3 \
        # XML Utils
        xmlstarlet 
	
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \  
        # GNU parallel
        parallel \
        #  R*-tree implementation - Required for earthpy, geoviews (3MB)
        libspatialindex-dev \
        # Search text and binary files
        yara \
        # Minimalistic C client for Redis
        libhiredis-dev \
        # postgresql client
        libpq-dev \
        # mysql client (10MB)
        libmysqlclient-dev \
        # mariadb client (7MB)
        # libmariadbclient-dev \
        # image processing library (6MB), required for tesseract
        libleptonica-dev \
        # GEOS library (3MB)
        libgeos-dev 
        
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \  
    # style sheet preprocessor
        less \
        # Print dir tree
        tree \
        # Bash autocompletion functionality
        bash-completion \
        # ping support
        iputils-ping \
        # Map remote ports to localhosM
        socat \
        # Json Processor
        jq \
        rsync \
        # sqlite3 driver - required for pyenv
        libsqlite3-dev 
	
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \  
        # VCS:
        subversion \
        jed \
        # odbc drivers
        unixodbc unixodbc-dev \
        # Image support
        libtiff-dev \
        libjpeg-dev \
        libpng-dev \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxext-dev \
        libxrender1 \
        libzmq3-dev \
        # protobuffer support
        protobuf-compiler \
        libprotobuf-dev \
        libprotoc-dev \
        autoconf \
        automake \
        libtool 
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \  
        cmake  \
        fonts-liberation \
        google-perftools 
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \  
        # Compression Libs
        # also install rar/unrar? but both are propriatory or unar (40MB)
        zip \
        gzip \
        unzip \
        bzip2 \
        lzop 
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \  
	# deprecates bsdtar (https://ubuntu.pkgs.org/20.04/ubuntu-universe-i386/libarchive-tools_3.4.0-2ubuntu1_i386.deb.html)
        libarchive-tools 
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \  
        zlib1g \
	zlib1g-dev 
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        # unpack (almost) everything with one command
        unp
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        liblzma-dev \
        zlib1g-dev 
	
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \   
    git
    
RUN apt-get update --fix-missing && \
    apt-get install -y apt-utils && \
    apt-get upgrade -y && \
    apt-get update && \
    apt-get install -y --no-install-recommends \   
    snapd &&\
    ln -s /var/lib/snapd/snap /snap 
 
# RUN snap install telegram-desktop 

ENV \
    # TODO: CONDA_DIR is deprecated and should be removed in the future
    CONDA_DIR=/opt/conda \
    CONDA_ROOT=/opt/conda \
    PYTHON_VERSION="3.9.10" \
    CONDA_PYTHON_DIR=/opt/conda/lib/python3.9 \
    MINICONDA_VERSION=4.10.3 \
    MINICONDA_MD5=8c69f65a4ae27fb41df0fe552b4a8a3b \
    CONDA_VERSION=4.10.3

RUN wget --no-verbose https://repo.anaconda.com/miniconda/Miniconda3-py39_${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    echo "${MINICONDA_MD5} *miniconda.sh" | md5sum -c - && \
    /bin/bash ~/miniconda.sh -b -p $CONDA_ROOT && \
    export PATH=$CONDA_ROOT/bin:$PATH && \
    rm ~/miniconda.sh && \
    # Configure conda
    # TODO: Add conde-forge as main channel -> remove if testted
    # TODO, use condarc file
    $CONDA_ROOT/bin/conda config --system --add channels conda-forge && \
    $CONDA_ROOT/bin/conda config --system --set auto_update_conda False && \
    $CONDA_ROOT/bin/conda config --system --set show_channel_urls True && \
    $CONDA_ROOT/bin/conda config --system --set channel_priority strict && \
    # Deactivate pip interoperability (currently default), otherwise conda tries to uninstall pip packages
    $CONDA_ROOT/bin/conda config --system --set pip_interop_enabled false && \
    # Update conda
    $CONDA_ROOT/bin/conda update -y -n base -c defaults conda && \
    $CONDA_ROOT/bin/conda update -y setuptools && \
    $CONDA_ROOT/bin/conda install -y conda-build && \
    # Update selected packages - install python 3.8.x
    $CONDA_ROOT/bin/conda install -y --update-all python=$PYTHON_VERSION && \
    # Link Conda
    ln -s $CONDA_ROOT/bin/python /usr/local/bin/python && \
    ln -s $CONDA_ROOT/bin/conda /usr/bin/conda && \
    # Update
    $CONDA_ROOT/bin/conda install -y pip && \
    $CONDA_ROOT/bin/pip install --upgrade pip && \
    chmod -R a+rwx /usr/local/bin/ && \
    # Cleanup - Remove all here since conda is not in path as of now
    # find /opt/conda/ -follow -type f -name '*.a' -delete && \
    # find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    $CONDA_ROOT/bin/conda clean -y --packages && \
    $CONDA_ROOT/bin/conda clean -y -a -f  && \
    $CONDA_ROOT/bin/conda build purge-all && \
    # Fix permissions
    fix-permissions.sh $CONDA_ROOT && \
    clean-layer.sh

ENV PATH=$CONDA_ROOT/bin:$PATH

# There is nothing added yet to LD_LIBRARY_PATH, so we can overwrite
ENV LD_LIBRARY_PATH=$CONDA_ROOT/lib

# Install pyenv to allow dynamic creation of python versions
RUN git clone https://github.com/pyenv/pyenv.git $RESOURCES_PATH/.pyenv && \
    # Install pyenv plugins based on pyenv installer
    git clone https://github.com/pyenv/pyenv-virtualenv.git $RESOURCES_PATH/.pyenv/plugins/pyenv-virtualenv  && \
    git clone https://github.com/pyenv/pyenv-doctor.git $RESOURCES_PATH/.pyenv/plugins/pyenv-doctor && \
    git clone https://github.com/pyenv/pyenv-update.git $RESOURCES_PATH/.pyenv/plugins/pyenv-update && \
    git clone https://github.com/pyenv/pyenv-which-ext.git $RESOURCES_PATH/.pyenv/plugins/pyenv-which-ext && \
    apt-get update && \
    # TODO: lib might contain high vulnerability
    # Required by pyenv
    apt-get install -y --no-install-recommends libffi-dev && \
    clean-layer.sh

# Add pyenv to path
ENV PATH=$RESOURCES_PATH/.pyenv/shims:$RESOURCES_PATH/.pyenv/bin:$PATH \
    PYENV_ROOT=$RESOURCES_PATH/.pyenv

# Install pipx
RUN pip install pipx && \
    # Configure pipx
    python -m pipx ensurepath && \
    # Cleanup
    clean-layer.sh
ENV PATH=$HOME/.local/bin:$PATH

RUN \
    apt-get update && \
    # https://nodejs.org/en/about/releases/ use even numbered releases, i.e. LTS versions
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - && \
    apt-get install -y nodejs && \
    # As conda is first in path, the commands 'node' and 'npm' reference to the version of conda.
    # Replace those versions with the newly installed versions of node
    rm -f /opt/conda/bin/node && ln -s /usr/bin/node /opt/conda/bin/node && \
    rm -f /opt/conda/bin/npm && ln -s /usr/bin/npm /opt/conda/bin/npm && \
    # Fix permissions
    chmod a+rwx /usr/bin/node && \
    chmod a+rwx /usr/bin/npm && \
    # Fix node versions - put into own dir and before conda:
    mkdir -p /opt/node/bin && \
    ln -s /usr/bin/node /opt/node/bin/node && \
    ln -s /usr/bin/npm /opt/node/bin/npm && \
    # Update npm
    /usr/bin/npm install -g npm && \
    # Install Yarn
    /usr/bin/npm install -g yarn && \
    # Install typescript
    /usr/bin/npm install -g typescript && \
    # Install webpack - 32 MB
    /usr/bin/npm install -g webpack && \
    # Install node-gyp
    /usr/bin/npm install -g node-gyp && \
    # Update all packages to latest version
    /usr/bin/npm update -g 
    
RUN \
    # Use staging channel to get newest xfce4 version (4.16)
    add-apt-repository -y ppa:xubuntu-dev/staging && \
    apt-get update && \
    apt-get install -y --no-install-recommends xfce4 && \
    apt-get install -y --no-install-recommends gconf2 && \
    apt-get install -y --no-install-recommends xfce4-terminal && \
    apt-get install -y --no-install-recommends xfce4-clipman && \
    apt-get install -y --no-install-recommends xterm && \
    apt-get install -y --no-install-recommends --allow-unauthenticated xfce4-taskmanager  && \
    # Install dependencies to enable vncserver
    apt-get install -y --no-install-recommends xauth xinit dbus-x11 && \
    # Install gdebi deb installer
    apt-get install -y --no-install-recommends gdebi && \
    # Search for files
    apt-get install -y --no-install-recommends catfish && \
    apt-get install -y --no-install-recommends font-manager && \
    # vs support for thunar
    apt-get install -y thunar-vcs-plugin && \
    # Streaming text editor for large files - klogg is alternative to glogg
    apt-get install -y --no-install-recommends libqt5concurrent5 libqt5widgets5 libqt5xml5 && \
    wget --no-verbose https://github.com/variar/klogg/releases/download/v20.12/klogg-20.12.0.813-Linux.deb -O $RESOURCES_PATH/klogg.deb && \
    dpkg -i $RESOURCES_PATH/klogg.deb && \
    rm $RESOURCES_PATH/klogg.deb && \
    # Disk Usage Visualizer
    apt-get install -y --no-install-recommends baobab && \
    # Lightweight text editor
    apt-get install -y --no-install-recommends mousepad && \
    apt-get install -y --no-install-recommends vim && \
    # Process monitoring
    apt-get install -y --no-install-recommends htop && \
    # Install Archive/Compression Tools: https://wiki.ubuntuusers.de/Archivmanager/
    apt-get install -y p7zip p7zip-rar && \
    apt-get install -y --no-install-recommends thunar-archive-plugin && \
    apt-get install -y xarchiver && \
    # DB Utils
    apt-get install -y --no-install-recommends sqlitebrowser && \
#     # Install nautilus and support for sftp mounting
#     apt-get install -y --no-install-recommends nautilus gvfs-backends && \
#     # Install gigolo - Access remote systems
#     apt-get install -y --no-install-recommends gigolo gvfs-bin && \
#     # xfce systemload panel plugin - needs to be activated
#     # apt-get install -y --no-install-recommends xfce4-systemload-plugin && \
#     # Leightweight ftp client that supports sftp, http, ...
#     apt-get install -y --no-install-recommends gftp && \
#     # Install chrome
#     # sudo add-apt-repository ppa:system76/pop
#     add-apt-repository ppa:saiarcot895/chromium-beta && \
#     apt-get update && \
#     apt-get install -y chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg && \
#     ln -s /usr/bin/chromium-browser /usr/bin/google-chrome && \
#     # Cleanup
#     apt-get purge -y pm-utils xscreensaver* && \
#     # Large package: gnome-user-guide 50MB app-install-data 50MB
#     apt-get remove -y app-install-data gnome-user-guide && \
    clean-layer.sh


COPY resources/libraries ${RESOURCES_PATH}/libraries

RUN \
    # Link Conda - All python are linke to the conda instances
    # Linking python 3 crashes conda -> cannot install anyting - remove instead
    # ln -s -f $CONDA_ROOT/bin/python /usr/bin/python3 && \
    # if removed -> cannot use add-apt-repository
    # rm /usr/bin/python3 && \
    # rm /usr/bin/python3.5
    ln -s -f $CONDA_ROOT/bin/python /usr/bin/python && \
    apt-get update && \
    # upgrade pip
    pip install --upgrade pip && \
    # If minimal flavor - install

        # Install mkl for faster computations
        conda install -y --update-all 'python='$PYTHON_VERSION mkl-service mkl ; \

    # Install some basics - required to run container
    conda install -y --update-all \
            'python='$PYTHON_VERSION \
            'ipython=7.24.*' \
            'notebook=6.4.*' \
            'jupyterlab=3.0.*' \
            # TODO: nbconvert 6.x makes problems with template_path
            'nbconvert=5.6.*' \
            # TODO: temp fix: yarl version 1.5 is required for lots of libraries.
            'yarl==1.5.*' \
            # TODO install scipy, numpy, sklearn, and numexpr via conda for mkl optimizaed versions: https://docs.anaconda.com/mkl-optimizations/
            'scipy==1.7.*' \
            'numpy==1.19.*' \
            scikit-learn \
            numexpr && \
            # installed via apt-get and pip: protobuf \
            # installed via apt-get: zlib  && \
    # Switch of channel priority, makes some trouble
    conda config --system --set channel_priority false && \
    # Install minimal pip requirements
    # OpenMPI support
    apt-get install -y --no-install-recommends libopenmpi-dev openmpi-bin && \
    conda install -y --freeze-installed  \
        'python='$PYTHON_VERSION \
        boost \
        mkl-include && \
    # Install mkldnn
    conda install -y --freeze-installed -c mingfeima mkldnn && \
    # Install pytorch - cpu only
    conda install -y -c pytorch "pytorch==1.9.*" cpuonly && \
    # Install light pip requirements
    pip install --no-cache-dir --upgrade --upgrade-strategy only-if-needed -r ${RESOURCES_PATH}/libraries/requirements-light.txt && \
    # If light light flavor - exit here
    if [ "$WORKSPACE_FLAVOR" = "light" ]; then \
        # Fix permissions
        fix-permissions.sh $CONDA_ROOT && \
        # Cleanup
        clean-layer.sh && \
        exit 0 ; \
    fi && \
    # libartals == 40MB liblapack-dev == 20 MB
    apt-get install -y --no-install-recommends liblapack-dev libatlas-base-dev libeigen3-dev libblas-dev && \
    # pandoc -> installs libluajit -> problem for openresty
    # HDF5 (19MB)
    apt-get install -y --no-install-recommends libhdf5-dev && \
    # TBB threading optimization
    apt-get install -y --no-install-recommends libtbb-dev && \
    # required for tesseract: 11MB - tesseract-ocr-dev?
    apt-get install -y --no-install-recommends libtesseract-dev && \
    pip install --no-cache-dir tesserocr && \
    # TODO: installs tenserflow 2.4 - Required for tensorflow graphics (9MB)
    apt-get install -y --no-install-recommends libopenexr-dev && \
    #pip install --no-cache-dir tensorflow-graphics==2020.5.20 && \
    # GCC OpenMP (GOMP) support library
    apt-get install -y --no-install-recommends libgomp1 && \
    # Install Intel(R) Compiler Runtime - numba optimization
    # TODO: don't install, results in memory error: conda install -y --freeze-installed -c numba icc_rt && \
    # Install libjpeg turbo for speedup in image processing
    conda install -y --freeze-installed libjpeg-turbo && \
    # Add snakemake for workflow management
    conda install -y -c bioconda -c conda-forge snakemake-minimal && \
    # Add mamba as conda alternativ
    conda install -y -c conda-forge mamba && \
    # Faiss - A library for efficient similarity search and clustering of dense vectors.
    conda install -y --freeze-installed faiss-cpu && \
    # Install full pip requirements
    pip install --no-cache-dir --upgrade --upgrade-strategy only-if-needed --use-deprecated=legacy-resolver -r ${RESOURCES_PATH}/libraries/requirements-full.txt && \
    # Setup Spacy
    # Spacy - download and large language removal
    python -m spacy.en.download all  && \
    python -m spacy.ru.download all 
	
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
LABEL maintainer="dev@deb.com"

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
