ARG CENTOS_RELEASE
FROM centos:${CENTOS_RELEASE}
ARG CENTOS_RELEASE
ENV CENTOS_RELEASE ${CENTOS_RELEASE}
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
