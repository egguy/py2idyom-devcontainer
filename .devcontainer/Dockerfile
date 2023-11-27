FROM mcr.microsoft.com/devcontainers/anaconda:0-3

ARG USERNAME=vscode
ARG USER_UID=1001
ARG USER_GID=$USER_UID
ENV HOME=/home/${USERNAME}

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
# COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# libsqlite3-dev + emacs is needed for idyom
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends sbcl emacs libsqlite3-dev

RUN mkdir -p /home/${USERNAME} && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME} && usermod -d /home/${USERNAME} ${USERNAME}

USER ${USERNAME}
WORKDIR  /home/${USERNAME}


COPY idyom_install/install_idyom.sh .

RUN ./install_idyom.sh

RUN pip install py2lispIDyOM