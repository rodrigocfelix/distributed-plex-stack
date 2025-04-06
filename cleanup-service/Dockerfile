FROM alpine:latest

# Create config directory (good practice even though it will be mounted)
# This ensures the container can still function if the volume mount fails
RUN mkdir -p /config

# Copy our cleanup script
COPY cleanup-script.sh /usr/local/bin/cleanup-script.sh
RUN chmod +x /usr/local/bin/cleanup-script.sh

# Default environment variables
ENV CRON_SCHEDULE="0 0 * * *"

# Create a wrapper script for the cron job
RUN echo '#!/bin/sh' > /entrypoint.sh && \
    echo 'echo "${CRON_SCHEDULE} /usr/local/bin/cleanup-script.sh" > /etc/crontabs/root' >> /entrypoint.sh && \
    echo 'chmod 644 /etc/crontabs/root' >> /entrypoint.sh && \
    echo 'exec crond -f -l 2 -L /dev/stdout' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Start cron using the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
