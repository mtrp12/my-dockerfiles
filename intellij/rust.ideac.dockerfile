FROM base-ideac:latest

ARG USERNAME
ENV DEBIAN_FRONTEND=noninteractive

USER ${USERNAME}

RUN wget https://sh.rustup.rs -O- | bash -s -- -y \
    && bash -c "source /home/${USERNAME}/.cargo/env \
    && rustup update \
    && rustup component add rls rust-analysis rust-src rustfmt clippy \
    && mkdir -p ~/.local/share/bash-completion/completions \
    && rustup completions bash >> ~/.local/share/bash-completion/completions/rustup \
    && rustup completions bash cargo >> ~/.local/share/bash-completion/completions/cargo \
    && rustup show"

ENV DEBIAN_FRONTEND=