FROM base-ideac:latest

ARG USERNAME
ENV DEBIAN_FRONTEND=noninteractive

USER $USERNAME

RUN echo "Installing required packages..." \
    && sudo apt-get update \
    && sudo apt-get -y --no-install-recommends install curl zip unzip \
    #
    && echo "Cleaning up installation packages and archives..." \
    && sudo apt-get -qq -y autoremove \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/* \
    #
    && echo "Installing SDKMAN! ..." \
    && sh -c "wget https://get.sdkman.io -O- | /bin/bash" \
    # && bash -c 'source /home/${USERNAME}/.sdkman/bin/sdkman-init.sh' \
    #
    && echo "Installing ZULU JDK 7..." \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk list java | grep 7.0.*zulu | sdk install java $(cut -d\| -f6)' \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk flush archives && sdk flush temp' \
    #
    && echo "Installing AdoptOpenJDK 8 (hotspot jvm)" \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk list java | grep 8.0.*hs-adpt | sdk install java $(cut -d\| -f6)' \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk flush archives && sdk flush temp' \
    #
    && echo "Installing AdoptOpenJDK 11 (hotspot jvm)" \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk list java | grep 11.0.2*hs-adpt | sdk install java $(cut -d\| -f6)' \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk flush archives && sdk flush temp' \
    #
    && echo "Installing GRADLE..." \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk install gradle' \
    && /bin/bash -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk flush archives && sdk flush temp'

ENV DEBIAN_FRONTEND=
CMD [ "/opt/ideac/bin/idea.sh" ]