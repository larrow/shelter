FROM fsword/alpine-ruby:onbuild

ENV REDIS_URL "redis://redis/0"

CMD ["bundle", "exec", "sidekiq", "-r", "./config/boot.rb"]
