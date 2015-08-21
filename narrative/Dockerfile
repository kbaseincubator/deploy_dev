FROM kbase/narrative:1.0.3
MAINTAINER Shane Canon scanon@lbl.gov

USER root
ADD ./ssl /tmp/ssl
RUN cat /tmp/ssl/proxy.crt  >> /etc/ssl/certs/ca-certificates.crt && \
    cat /tmp/ssl/proxy.crt  >> /usr/local/lib/python2.7/dist-packages/requests/cacert.pem && \
    cat /tmp/ssl/proxy.crt  >> /usr/local/lib/python2.7/dist-packages/certifi/cacert.pem && \
    cat /tmp/ssl/proxy.crt  >> /kb/deployment/services/narrative-venv/lib/python2.7/site-packages/pip/_vendor/requests/cacert.pem && \
    cat /tmp/ssl/proxy.crt > /etc/ssl/certs/`openssl x509 -noout -hash -in /tmp/ssl/proxy.crt`.0

USER nobody
