FROM nginx:latest
COPY index.html /var/www/html/
EXPOSE 80:80
CMD ["nginx", "-g", "deamon off;"]
