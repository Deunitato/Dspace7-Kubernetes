#
# The contents of this file are subject to the license and copyright
# detailed in the LICENSE and NOTICE files at the root of the source
# tree and available online at
#
# http://www.dspace.org/license/
#


# Build me with docker build -t alpdspace.azurecr.io/dspace-solr -f dspace/src/main/docker/solr/Dockerfile .
# Login with `az acr login --name ALPDspace`
# Push image `docker image push alpdspace.azurecr.io/dspace-solr:latest `

# Define a 'dspace' alias for our latest v7 image
FROM dspace/dspace:dspace-7_x as dspace

# Pin to Solr v8.x
FROM solr:8.8
# Directory on 'dspace' image (see above) where DSpace is installed
ENV DSPACE_INSTALL=/dspace
# User that Solr runs as
ENV SOLR_USER=solr
# Expose Solr on localhost:8983
EXPOSE 8983 8983

# Solr Data Directory (NOTE: logs are in /var/solr/logs)
WORKDIR /var/solr/data

USER $SOLR_USER

# # Mkdir first
# RUN \
#     mkdir -p /opt/solr/server/solr/configsets/authority && \
#     mkdir -p /opt/solr/server/solr/configsets/oai && \
#     mkdir -p /opt/solr/server/solr/configsets/search && \
#     mkdir -p /opt/solr/server/solr/configsets/statistics

# Create DSpace-specific Solr cores (under our WORKDIR)
# RUN \
#     init-var-solr && \
#     precreate-core authority /opt/solr/server/solr/configsets/authority && \
#     precreate-core oai /opt/solr/server/solr/configsets/oai && \
#     precreate-core search  /opt/solr/server/solr/configsets/search && \
#     precreate-core statistics /opt/solr/server/solr/configsets/search

# Copy the DSpace-specific Solr schemas & configs (from our 'dspace' image)
# into corresponding Solr core directory
COPY --from=dspace --chown=$SOLR_USER:$SOLR_USER $DSPACE_INSTALL/solr/authority authority/
COPY --from=dspace --chown=$SOLR_USER:$SOLR_USER $DSPACE_INSTALL/solr/oai oai/
COPY --from=dspace --chown=$SOLR_USER:$SOLR_USER $DSPACE_INSTALL/solr/search search/
COPY --from=dspace --chown=$SOLR_USER:$SOLR_USER $DSPACE_INSTALL/solr/statistics statistics/