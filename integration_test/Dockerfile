FROM ruby:2.3

# upgrade alpine version to support unf_ext
#RUN sed -i -e 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
#      && sed -i -e 's/v3\.3/v3.4/g' /etc/apk/repositories \
#      && apk update \
#      && apk upgrade --available

WORKDIR /usr/src/app
COPY ["Gemfile", "Gemfile.lock", "/usr/src/app/"]
RUN bundle install
COPY . /usr/src/app

CMD sleep 15 && rspec
