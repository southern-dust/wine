FROM southern-dust/x11client:latest
MAINTAINER Jan Suchotzki <jan@suchotzki.de>
MAINTAINER southern-dust <southerndust972106614@gmail.com>

# Inspired by monokrome/wine
#ENV WINE_MONO_VERSION 0.0.8
USER root

# Install some tools required for creating the image
RUN echo "deb http://mirrors.ustc.edu.cn/debian/ buster main contrib non-free" > /etc/apt/sources.list \
&&  echo "deb http://mirrors.ustc.edu.cn/debian-security buster/updates main contrib non-free" >> /etc/apt/sources.list

RUN apt-get update \
	&& apt-get install -y --install-recommends \
		curl \
		unzip \
		ca-certificates \
		gpg \
		wget \
		vim \
		apt-transport-https

# Add WineHQ Repository
RUN echo "deb https://dl.winehq.org/wine-builds/debian/ buster main" >> /etc/apt/sources.list \
&& wget -nc https://dl.winehq.org/wine-builds/winehq.key \
&& apt-key add winehq.key

# To fix up dependencies, we should install libfaudio first
RUN echo "deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10 ./" >> /etc/apt/sources.list \
&& wget -nc https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/Release.key \
&& apt-key add Release.key

# Install wine and related packages
RUN dpkg --add-architecture i386 \
		&& apt-get update \
		&& apt-get install -y --install-recommends winehq-devel \
		&& apt-get install -y --install-recommends \
				playonlinux \
				winetricks \
		&& rm -rf /var/lib/apt/lists/*

# Use the latest version of winetricks
# RUN curl -SL 'https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks' -o /usr/local/bin/winetricks \
#		&& chmod +x /usr/local/bin/winetricks

# Get latest version of mono for wine
#RUN mkdir -p /usr/share/wine/mono \
#	&& curl -SL 'http://sourceforge.net/projects/wine/files/Wine%20Mono/$WINE_MONO_VERSION/wine-mono-$WINE_MONO_VERSION.msi/download' -o /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi \
#	&& chmod +x /usr/share/wine/mono/wine-mono-$WINE_MONO_VERSION.msi

# Wine really doesn't like to be run as root, so let's use a non-root user
USER xclient
ENV HOME /home/xclient
#ENV WINEPREFIX /home/xclient/.wine
#ENV WINEARCH win32

# Use xclient's home dir as working dir
WORKDIR /home/xclient

#RUN echo "alias winegui='wine explorer /desktop=DockerDesktop,1024x768'" > ~/.bash_aliases 
RUN echo "alias winegui='wine explorer /desktop=DockerDesktop'" > ~/.bash_aliases 
