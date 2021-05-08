ARG BASE_IMAGE
FROM $BASE_IMAGE AS base
COPY build/tmp/ /build/

# Install APT packages (if any) from packagelist
COPY build/tmp/packagelist /build/packagelist
RUN if [ -s /build/packagelist ] ; then \
    apt-get update \
    && apt-get install --yes --no-install-recommends $(cat /build/packagelist | xargs) \
    && rm -rf /var/lib/apt/lists/* ; \
fi

# Install Python packages (if any) from pip-requirements.txt
COPY build/tmp/pip /build/pip
RUN if [ ! -z $(ls /build/pip) ] ; then for path in /build/pip/pip*-req*.txt ; \
  do $(basename ${path} | cut -d '-' -f 1) install --no-cache-dir -r ${path} ; done ; fi

# Copy any installation resources from the host
COPY build/resources /build/resources

################################################################################
# DEVELOPMENT TARGET - generate development-friendly image
################################################################################
FROM base AS development-image
ARG WORKDIR
ENV WORKDIR $WORKDIR
WORKDIR $WORKDIR
# Install development tools

################################################################################
# PRE-PRODUCTION STAGE - transform workspace into production-ready state
################################################################################
FROM base AS pre-production
ARG WORKDIR
COPY workspace $WORKDIR
# Build workspace and/or remove files not intended for production

################################################################################
# PRODUCTION TARGET - generate final self-contained image
################################################################################
FROM base AS production-image
ARG WORKDIR
ENV WORKDIR $WORKDIR
WORKDIR $WORKDIR
# Copy the clean workspace into production image
COPY --from=pre-production workspace $WORKDIR
