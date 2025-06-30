FROM hshar/webapp:latest
COPY . /var/www/html
EXPOSE 80
CMD ["apache2-foreground"]
