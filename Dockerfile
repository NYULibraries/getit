FROM ruby:2.5

# Env
ENV INSTALL_PATH /app
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV USER docker

RUN groupadd -g 2000 docker -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g docker docker

WORKDIR $INSTALL_PATH

# install phantomjs
RUN apt-get update -y && apt-get install -y --no-install-recommends npm \
  && npm config set user 0 \
  && npm install -g phantomjs-prebuilt \
  && npm cache clean --force \
  && apt-get clean && rm -rf /var/lib/apt/lists/* 

# install wait-for-it script
RUN wget -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh \
  && chmod a+x /tmp/wait-for-it.sh \
  && chown -R docker:docker /tmp/wait-for-it.sh 

# Bundle install
COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v '2.2.3' \
  && bundle config --local github.https true \
  && bundle config set without 'no_docker' \
  && bundle install --jobs 20 --retry 5 \
  && chown -R docker:docker $BUNDLE_PATH \
  && rm -rf /root/.bundle && rm -rf /root/.gem \
  && rm -rf /usr/local/bundle/cache

USER $USER

# needed for phantomjs: https://stackoverflow.com/questions/53355217/genymotion-throws-libssl-conf-so-cannot-open-shared-object-file-no-such-file-o
ENV OPENSSL_CONF=/etc/ssl/

# avoid ssh key verification failures on runtime
RUN mkdir ~/.ssh && touch ~/.ssh/known_hosts && ssh-keyscan github.com >> ~/.ssh/known_hosts

COPY --chown=docker:docker . .

EXPOSE 3000


CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
