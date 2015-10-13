FROM kbase/narrative:develop
MAINTAINER Shane Canon scanon@lbl.gov

USER root
ADD ./ssl /tmp/ssl
RUN cat /tmp/ssl/proxy.crt  >> /etc/ssl/certs/ca-certificates.crt && \
    cat /tmp/ssl/proxy.crt  >> /usr/local/lib/python2.7/dist-packages/requests/cacert.pem && \
    cat /tmp/ssl/proxy.crt  >> /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem && \
    cat /tmp/ssl/proxy.crt  >> /kb/deployment/services/narrative-venv/lib/python2.7/site-packages/pip/_vendor/requests/cacert.pem && \
    cat /tmp/ssl/proxy.crt > /etc/ssl/certs/`openssl x509 -noout -hash -in /tmp/ssl/proxy.crt`.0

# Narrative uses a virtual env which is located at..
#  /kb/deployment/services/narrative-venv/bin/pip install bokeh
#
# If you wish to add a python module, you can do something like this:
#
# RUN /kb/deployment/services/narrative-venv/bin/pip install bokeh

USER nobody
