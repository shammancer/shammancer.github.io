FROM localhost/sgi-gems AS build
COPY config.rb /usr/src/app
COPY source /usr/src/app/source
COPY styles /usr/src/app/styles
COPY data /usr/src/app/data
ENV LANG=C.UTF-8
RUN middleman build --verbose

FROM httpd:2.4
COPY --from=build /usr/src/app/build /usr/local/apache2/htdocs/
