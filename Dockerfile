FROM ubuntu:bionic

MAINTAINER SpyDev0 <mail@mail.net>

USER root

# PosgreSQL configuration
COPY ./scripts/db.sql /tmp/
COPY ./conf/database.yml /usr/share/metasploit-framework/config/
COPY ./conf/tmux.conf /root/.tmux.conf

# Startup script
COPY ./scripts/init.sh /usr/local/bin/init.sh

#Update msf
COPY ./scripts/update.sh /usr/local/bin/update.sh

# Installation
RUN apt-get update \
  && apt-get install -y \
    curl postgresql postgresql-contrib postgresql-client \
    apt-transport-https gnupg2\
    nmap tmux\
	mc tor\
  && /etc/init.d/postgresql start && su postgres -c "psql -f /tmp/db.sql" \
  && curl -fsSL https://apt.metasploit.com/metasploit-framework.gpg.key | apt-key add - \
  && echo "deb https://apt.metasploit.com/ jessie main" >> /etc/apt/sources.list \
  && apt-get update -qq \
  && apt-get install -y metasploit-framework \
  && apt-get remove -y apt-transport-https postgresql-contrib postgresql-client \
  && rm -rf /var/lib/apt/lists/*

# Configuration and sharing folders
VOLUME /root/.msf4/
VOLUME /tmp/data/

# For backconnect shellcodes (or payloads as if you want to use fancy names)
EXPOSE 4444

# Armitage/MSFRPC connect port
EXPOSE 55553
EXPOSE 55554

# For browser exploits
EXPOSE 80
EXPOSE 8080
EXPOSE 443
EXPOSE 8081

# Locales for tmux
ENV LANG C.UTF-8


CMD "update.sh"
CMD "init.sh"
