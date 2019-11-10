#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM python:3.7

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Or your actual UID, GID on Linux if not the default 1000
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get -y install git procps lsb-release \
    #
    # Install pylint
    && pip --disable-pip-version-check --no-cache-dir install pylint \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# install firefox
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A6DCF7707EBC211F \
    && apt-get update \
    && apt install -y software-properties-common \
    && apt-add-repository "deb http://ppa.launchpad.net/ubuntu-mozilla-security/ppa/ubuntu bionic main" \
    && apt-get install -y iceweasel
# install geckodriver
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz \
    && sh -c 'tar -x geckodriver -zf geckodriver-v0.26.0-linux64.tar.gz -O > /usr/bin/geckodriver' \
    && chmod +x /usr/bin/geckodriver \
    && rm geckodriver-v0.26.0-linux64.tar.gz

# Install vnc, xvfb in order to create a 'fake' display and firefox
# RUN  apt-get install -y x11vnc xvfb
# RUN  mkdir ~/.vnc
# Setup a password
# RUN  x11vnc -storepasswd 1234 ~/.vnc/passwd
# Autostart firefox (might not be the best way to do it, but it does the trick)
# RUN  bash -c 'echo "firefox" >> /.bashrc'

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=