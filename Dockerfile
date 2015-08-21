# Dockerfile that builds a minimal container for IPython + narrative
#
# Copyright 2013 The Regents of the University of California,
# Lawrence Berkeley National Laboratory
# United States Department of Energy
# The DOE Systems Biology Knowledgebase (KBase)
# Made available under the KBase Open Source License
#
FROM kbase/deplbase:latest
MAINTAINER Shane Canon scanon@lbl.gov


RUN cat ssl/proxy.crt  >> /etc/ssl/certs/ca-certificates.crt && \
    cat ssl/proxy.crt > /etc/ssl/certs/`openssl x509 -noout -hash -in ssl/proxy.crt`.0 && \
    cat ssl/proxy.crt  >> /usr/local/lib/python2.7/dist-packages/requests/cacert.pem && \
    cat ssl/narrative.crt  >> /etc/ssl/certs/ca-certificates.crt && \
    cat ssl/narrative.crt > /etc/ssl/certs/`openssl x509 -noout -hash -in ssl/narrative.crt`.0 && \
    cpanm  -i Time::ParseDate

