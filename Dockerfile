FROM hshar/webapp:latest
COPY . /var/www/html
EXPOSE 80
# Ensure Apache stays in foreground
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
