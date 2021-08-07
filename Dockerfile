ARG BASE_IMAGE
FROM $BASE_IMAGE AS base
COPY build/tmp/ /build/

# Configure the apt mirror
ARG APT_MIRROR=""
RUN if [ "${APT_MIRROR}" != "" ]; then if [ "${APT_MIRROR}" = "auto" ]; then \ 
  APT_MIRROR="mirror://mirrors.ubuntu.com/mirrors.txt"; fi && sed --in-place \
  "s|http://archive.ubuntu.com/ubuntu/|${APT_MIRROR}|g" /etc/apt/sources.list; \
  fi

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

# Create user account (if necessary)
ARG GROUP_ID
ARG USER_ID
ARG USER_NAME
RUN if [ "${USER_NAME}" != "root" ]; then \
  addgroup --gid ${GROUP_ID} ${USER_NAME} \
  && adduser --disabled-password --gecos '' --gid ${GROUP_ID} --uid ${USER_ID} ${USER_NAME} ; \
fi
USER ${USER_NAME}

ENV GEM_HOME="${HOME}/gems"
ENV PATH="${HOME}/gems/bin:$PATH"
RUN gem install jekyll bundler

# Setup workspace variables
ARG WORKDIR
ARG WORKSPACE_NAME
ENV WORKSPACE $WORKDIR/$WORKSPACE_NAME
WORKDIR $WORKDIR
################################################################################
# DEVELOPMENT TARGET - generate development-friendly image
################################################################################
FROM base AS development-image
# Install development tools

################################################################################
# PRE-PRODUCTION STAGE - transform workspace into production-ready state
################################################################################
FROM base AS pre-production
COPY $WORKSPACE_NAME $WORKSPACE
# Build workspace and/or remove files not intended for production

################################################################################
# PRODUCTION TARGET - generate final self-contained image
################################################################################
FROM base AS production-image
# Copy the clean workspace into production image
COPY --from=pre-production $WORKSPACE $WORKSPACE
