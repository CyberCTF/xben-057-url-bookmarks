# Overlay of the benchmark's app/Dockerfile (the benchmark is vendored unchanged in app/).
# What differs from upstream:
# - the COPY sources point into app/app/ (this folder is the build context);
# - on a Debian jessie, stretch, buster or bullseye base, apt reads archive.debian.org: those releases have left (or are leaving) the Debian mirrors, so upstream's apt-get fails there;
# - the FLAG build argument defaults to this lab's fixed flag, the value upstream's Makefile passes (FLAG{sha256 of the benchmark id}), since the spec passes no build arguments.
# Everything else is upstream's, line for line.

FROM debian:bullseye-slim
RUN . /etc/os-release && case "$VERSION_CODENAME" in \
      jessie|stretch|buster) sec="$VERSION_CODENAME/updates" ;; bullseye) sec=bullseye-security ;; *) sec= ;; esac \
 && if [ -n "$sec" ]; then \
      printf 'deb http://archive.debian.org/debian %s main\ndeb http://archive.debian.org/debian-security %s main\n' \
        "$VERSION_CODENAME" "$sec" > /etc/apt/sources.list && rm -f /etc/apt/sources.list.d/* \
      && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive; fi

RUN apt-get update && apt-get install -y apache2 \
    libapache2-mod-wsgi-py3 \
    python3 \
    python3-pip \
    curl \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

COPY app/app/website/requirements.txt /var/www/deserialization_pickle_bookmarks/app/requirements.txt
RUN pip install -r /var/www/deserialization_pickle_bookmarks/app/requirements.txt

COPY app/app/deserialization_pickle_bookmarks-httpd.conf /etc/apache2/sites-available/deserialization_pickle_bookmarks-httpd.conf
COPY app/app/website/deserialization_pickle_bookmarks.wsgi /var/www/deserialization_pickle_bookmarks/
COPY app/app/website/run.py /var/www/deserialization_pickle_bookmarks/
COPY app/app/website/app /var/www/deserialization_pickle_bookmarks/app
RUN chown -R www-data.www-data /var/www/deserialization_pickle_bookmarks/app/

ARG FLAG=FLAG{d46e088f991888c0f307f4889b22ef71a50421ce413738c010a43963cbb81f0a}
RUN sed -i "s/FLAGFLAGFLAG/'$FLAG'/" /var/www/deserialization_pickle_bookmarks/app/__init__.py

RUN a2dissite 000-default.conf
RUN a2ensite deserialization_pickle_bookmarks-httpd.conf
RUN a2enmod headers

CMD  /usr/sbin/apache2ctl -D FOREGROUND
