FROM ubuntu:latest

# container user config
ARG USERNAME=dev
ARG UID=1000
ARG GID=${UID}

# IdeaC Config
ARG IDEAC_MAJOR_VERSION=2019.2
ARG IDEAC_MINOR_VERSION=2019.2.3
# ARG IDEAC_CONFIG_DIR=.IdeaIC${IDEAC_MAJOR_VERSION}

# wget https://api.github.com/repos/microsoft/cascadia-code/releases/latest -O - | grep browser_download_url | awk '{print $2}' | xargs wget -O cascadia.ttf -q

# Download config
ARG FONT_URL=https://api.github.com/repos/microsoft/cascadia-code/releases/latest
ARG IDEA_URL=https://download.jetbrains.com/idea/ideaIC-${IDEAC_MINOR_VERSION}.tar.gz

ENV DEBIAN_FRONTEND=noninteractive

RUN echo "Updating apt repository list..." \
    && apt-get update \
    #
    && echo "Installing packages..." \
    && apt-get -y install --no-install-recommends \
    sudo wget libfontconfig1 fontconfig ca-certificates vim git openssh-client less \
    libxext-dev libxrender-dev libxtst-dev libfreetype6-dev \
    #
    && echo "Adding user: ${USERNAME} ..." \
    && groupadd --gid $GID $USERNAME \
    && useradd --uid $UID --gid $GID -s /bin/bash -m $USERNAME \
    #
    && echo "Configuring NOPASSWD sudo..." \
    && echo $USERNAME ALL=\(ALL:ALL\) NOPASSWD:ALL >> /etc/sudoers \
    #
    && echo "Cleaning up package installers..." \
    && apt-get -qq -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    #
    && echo "Downloading Cascadia Code font..." \
    && bash -c 'wget -q ${FONT_URL} -O- | grep browser_download_url | grep -o http.*[^\"] | xargs wget -O /usr/share/fonts/cascadia_code.ttf' \
    #
    && echo "Configuring font..." \
    && fc-cache -fv \
    && fc-list \
    #
    && echo "Creating IdeaC installation dir..." \
    && mkdir /opt/ideac

RUN echo "Downloading IdeaIC${IDEAC_MINOR_VERSION}..." \
    && wget ${IDEA_URL} -O /opt/ideac/ideac.tar.gz

WORKDIR /opt/ideac
RUN echo "Installing IdeaIC${IDEAC_MINOR_VERSION}" \
    && tar --strip-components=1 -xvf ideac.tar.gz \
    && echo "Cleaning up installer..." \
    && rm /opt/ideac/ideac.tar.gz

ENV DEBIAN_FRONTEND=

WORKDIR /home/${USERNAME}
USER ${USERNAME}
CMD [ "/opt/ideac/bin/idea.sh" ]
