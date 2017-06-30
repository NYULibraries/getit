FROM nyulibraries/rails

COPY Gemfile Gemfile.lock ./
RUN bundle config --global github.https true
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .

#CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
