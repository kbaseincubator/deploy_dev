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


# This is now in deploy_tools but we will leave it in a bit until things have propogated
#
RUN cat ssl/proxy.crt  >> /etc/ssl/certs/ca-certificates.crt && \
    cat ssl/proxy.crt > /etc/ssl/certs/`openssl x509 -noout -hash -in ssl/proxy.crt`.0 && \
    cat ssl/proxy.crt  >> /usr/local/lib/python2.7/dist-packages/requests/cacert.pem && \
    cat ssl/narrative.crt  >> /etc/ssl/certs/ca-certificates.crt && \
    cat ssl/narrative.crt > /etc/ssl/certs/`openssl x509 -noout -hash -in ssl/narrative.crt`.0 && \
    PUBLIC=$(grep baseurl= cluster.ini|sed 's/.*=//'|sed 's/:.*//') && \
    sed -i "s|api-url=$|api-url=http://$PUBLIC:8080/services/shock-api|" /kb/deployment//services/shock_service/conf/shock.cfg  && \
    cpanm  -i Time::ParseDate

# FIx start script if it exist
RUN [ -e /kb/deployment//services/fbaModelServices/start_service ] && sed -i 's/starman -D/starman/' /kb/deployment//services/fbaModelServices/start_service
