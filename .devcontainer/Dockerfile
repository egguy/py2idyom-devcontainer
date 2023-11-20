FROM mcr.microsoft.com/devcontainers/anaconda:0-3

# Copy environment.yml (if found) to a temp location so we update the environment. Also
# copy "noop.txt" so the COPY instruction does not fail if no environment.yml exists.
# COPY environment.yml* .devcontainer/noop.txt /tmp/conda-tmp/
RUN if [ -f "/tmp/conda-tmp/environment.yml" ]; then umask 0002 && /opt/conda/bin/conda env update -n base -f /tmp/conda-tmp/environment.yml; fi \
    && rm -rf /tmp/conda-tmp

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
     && apt-get -y install --no-install-recommends sbcl emacs

RUN mkdir quicklisp && cd quicklisp && curl -O https://beta.quicklisp.org/quicklisp.lisp && sbcl --load quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(ql:add-to-init-file)' --eval '(quit)' && cd .. && rm -rf quicklisp

COPY idyom_install/install_pt2.lisp idyom_install/install_pt3.lisp idyom_install/install_pt4.lisp quicklisp/

RUN cd quicklisp/ && sbcl --load install_pt2.lisp 

RUN mkdir -p idyom/db/ idyom/data/cache/ idyom/data/models/ idyom/data/resampling/

RUN mkdir quicklisp/local-projects/ && curl -L https://github.com/mtpearce/idyom/archive/refs/tags/v1.7.1.tar.gz > idyom.tar.gz && tar -xzf idyom.tar.gz -C quicklisp/local-projects/ && rm idyom.tar.gz

COPY idyom_install/install_idyom.sh .

RUN ./install_idyom.sh

RUN pip install py2lispIDyOM