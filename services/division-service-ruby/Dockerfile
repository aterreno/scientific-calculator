FROM ruby:3.2

# Install build dependencies
WORKDIR /app

COPY Gemfile .
RUN bundle install

COPY . .

EXPOSE 8004

CMD ["ruby", "app.rb"]