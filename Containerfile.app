FROM localhost/sgi-gems AS build
COPY config.rb /usr/src/app
COPY source /usr/src/app/source
COPY styles /usr/src/app/styles
COPY data /usr/src/app/data
ENV LANG=C.UTF-8
RUN middleman build --verbose
