# Use the official Nginx image from the Docker Hub
FROM nginx:latest

# Copy custom configuration file (if any)
# COPY nginx.conf /etc/nginx/nginx.conf

# Copy website content to the default nginx directory
COPY ./html /usr/share/nginx/html

# Expose port 80 to access the web server
EXPOSE 80

# Run Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
