FROM ideac-base:latest

ARG USERNAME=dev
ENV DEBIAN_FRONTEND=noninteractive

USER $USERNAME
RUN sudo apt-get update \
    && sudo apt-get -y --no-install-recommends install curl zip unzip \
    && sh -c "wget https://get.sdkman.io -O- | /bin/bash" \
    && bash -c 'source /home/${USERNAME}/.sdkman/bin/sdkman-init.sh' \
    && sudo apt-get clean \
    && sudo apt-get -y autoremove \
    && sudo rm -rf /var/lib/apt/lists/*
    # && /bin/bash -l -c 'sdk list java | grep 8.*hs-adpt | sdk install java $(cut -d\| -f6)'
RUN /bin/bash -l -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk list java | grep 7.0.*zulu | sdk install java $(cut -d\| -f6)' \
    && /bin/bash -l -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk list java | grep 8.0.*hs-adpt | sdk install java $(cut -d\| -f6)' \
    && /bin/bash -l -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk list java | grep 11.0.2*hs-adpt | sdk install java $(cut -d\| -f6)' \
    && /bin/bash -l -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk install gradle' \
    && /bin/bash -l -c 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh" && sdk flush archives && sdk flush temp'
    # && touch /home/${USERNAME}/exec.sh \
    # && chmod +x /home/${USERNAME}/exec.sh \
    # && echo '#!/bin/bash' > /home/${USERNAME}/exec.sh \
    # && echo 'source "/home/${USERNAME}/.sdkman/bin/sdkman-init.sh"' >> /home/${USERNAME}/exec.sh \
    # && echo 'sdk list java' >> /home/${USERNAME}/exec.sh \
    # && bash /home/${USERNAME}/exec.sh

# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 \
#     && echo 'deb http://repos.azulsystems.com/ubuntu stable main' > /etc/apt/sources.list.d/zulu.list \
#     && apt-get update \
#     && apt-get -y install java-common libasound2 zulu-7 zulu-8 zulu-11 \
#     && apt-get clean \
#     && apt-get -y autoremove \
#     && && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=
USER ${USERNAME}
CMD [ "/opt/ideac/bin/idea.sh" ]
# CMD [ "bash" ]