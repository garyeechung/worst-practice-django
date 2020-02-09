FROM python:3.7.6-slim-buster

USER root

RUN apt-get update && apt-get install -y \
    firefox-esr \
    chromium \
    git-core \
    xvfb \
    xsel \
    unzip \
    python-pytest \
    libgconf-2-4 \
    libncurses5 \
    libxml2-dev \
    libxslt-dev \
    libz-dev \
    xclip \
    wget

# Set timezone, or it would raise error when connect to Oracle
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install python packages
ADD ./requirements.txt /usr/local/worst-practice-django/requirements.txt
RUN pip install --upgrade pip && \
    cd /usr/local/worst-practice-django/ && \
    pip install -r requirements.txt

# GeckoDriver v0.26.0 
RUN wget -q "https://github.com/mozilla/geckodriver/releases/download/v0.26.0/geckodriver-v0.26.0-linux64.tar.gz" -O /tmp/geckodriver.tgz \
    && tar zxf /tmp/geckodriver.tgz -C /usr/bin/ \
    && rm /tmp/geckodriver.tgz

# chromeDriver 79.0.3945.36 
RUN wget -q "https://chromedriver.storage.googleapis.com/79.0.3945.36/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip

# xvfb - X server display
# RUN apt-get install -y xvfb-chromium
ADD xvfb-chromium /usr/bin/xvfb-chromium
RUN ln -s /usr/bin/xvfb-chromium /usr/bin/google-chrome \
    && chmod 777 /usr/bin/xvfb-chromium

# create symlinks to chromedriver and geckodriver (to the PATH)
RUN ln -s /usr/bin/geckodriver /usr/bin/chromium-browser \
    && chmod 777 /usr/bin/geckodriver \
    && chmod 777 /usr/bin/chromium-browser

# RUN mkdir /usr/local/worst-practice-django/

WORKDIR /usr/local/worst-practice-django

CMD ["/bin/bash"]

COPY docker-entrypoint.sh /usr/local/worst-practice-django/
RUN chmod 755 /usr/local/worst-practice-django/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/worst-practice-django/docker-entrypoint.sh"]