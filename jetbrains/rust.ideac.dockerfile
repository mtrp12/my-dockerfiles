FROM base-ideac:latest

ARG USERNAME
ENV DEBIAN_FRONTEND=noninteractive

USER ${USERNAME}

RUN echo "Installing Rust..." \
    && wget https://sh.rustup.rs -O- | bash -s -- -y \
    #
    && echo "Configuring environment..." \
    && echo "source /home/${USERNAME}/.cargo/env" >> /home/${USERNAME}/.bashrc \
    #
    && echo "Installing necessary rust crates..." \
    && bash -c "source /home/${USERNAME}/.cargo/env \
    && rustup update \
    && rustup component add rls rust-analysis rust-src rustfmt clippy \
    && rustup completions bash | sudo tee 1>/dev/null /etc/bash_completion.d/rustup \
    && rustup completions bash cargo | sudo tee 1>/dev/null /etc/bash_completion.d/cargo \
    && rustup show" \
    #
    && echo "Installing required tools (gcc, lldb etc.)..." \
    && sudo apt-get update \
    && sudo apt-get -y --no-install-recommends install gcc procps lsb-release lldb\
    #
    && echo "Cleaning up..." \
    && sudo apt-get -qq -y autoremove \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND=