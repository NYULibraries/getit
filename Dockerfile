FROM nyulibraries/selenium_chrome_headless_ruby:2.3.7-slim

ENV RUN_PACKAGES bash ca-certificates git nodejs default-libmysqlclient-dev ruby-mysql2
ENV BUILD_PACKAGES curl libcurl4-gnutls-dev build-essential zlib1g-dev wget

# Env
ENV INSTALL_PATH /app
ENV BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_BIN=/usr/local/bundle/bin \
    GEM_HOME=/usr/local/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"
ENV USER docker

RUN groupadd -g 1000 $USER -r && \
    useradd -u 1000 -r --no-log-init -m -d $INSTALL_PATH -g $USER $USER

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./
RUN apt-get update && apt-get -y --no-install-recommends install $BUILD_PACKAGES $RUN_PACKAGES \
  && bundle config --local github.https true \
  && gem install bundler && bundle install --without non_docker --jobs 20 --retry 5 \
  && chown -R docker:docker $BUNDLE_PATH \
  && wget --no-check-certificate -q -O - https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh > /tmp/wait-for-it.sh \
  && chmod a+x /tmp/wait-for-it.sh \
  && chown -R docker:docker /tmp/wait-for-it.sh \
  && apt-get --purge -y autoremove $BUILD_PACKAGES \
  && apt-get clean && rm -rf /var/lib/apt/lists/* \
USER $USER

COPY --chown=docker:docker . .

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
