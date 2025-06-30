# Test Dockerfile for Prometheus Exporter Plugin with OpenSearch 3.0.0
FROM opensearchproject/opensearch:3.0.0

# Switch to root to install plugin
USER root

# Copy the plugin ZIP file to the container
COPY build/distributions/prometheus-exporter-3.0.0.0.zip /tmp/

# Install the plugin
RUN /usr/share/opensearch/bin/opensearch-plugin install file:///tmp/prometheus-exporter-3.0.0.0.zip --batch

# Clean up
RUN rm /tmp/prometheus-exporter-3.0.0.0.zip

# Switch back to opensearch user
USER opensearch

# Configure OpenSearch for single-node testing
ENV discovery.type=single-node
ENV OPENSEARCH_INITIAL_ADMIN_PASSWORD=MyStrongPassword123!
ENV DISABLE_SECURITY_PLUGIN=true
# Expose OpenSearch port and metrics endpoint
EXPOSE 9200 9600

# Health check to verify OpenSearch is running
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:9200/_cluster/health || exit 1

# Start OpenSearch
CMD ["/usr/share/opensearch/opensearch-docker-entrypoint.sh"]
