FROM ruby:2.4.6-alpine

RUN apk add --update bash build-base curl dumb-init git less mariadb-dev mysql-client tzdata nodejs

SHELL ["/bin/bash", "-c"]
ENV LANG C.UTF-8

ENV BUNDLE_JOBS=8

# This UID here is dynamically added as a build arg by our pilot tool
RUN adduser -u 68151 -D -s /bin/bash pilotuser

ARG app_home=/apps/rubymine-sample
RUN mkdir -p $app_home
WORKDIR $app_home
RUN chown -R pilotuser /apps

USER pilotuser

ENTRYPOINT ["dumb-init", "/opt/project/entrypoint"]

CMD ["bundle", "exec", "rails", "server", "--port", "3005", "--binding", "0.0.0.0", "--pid", "/tmp/server.pid"]
