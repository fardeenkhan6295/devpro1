FROM nginx:latest
COPY index.html /var/www/html/
EXPOSE 8001:80
CMD ["nginx", "-g", "deamon off;"]
