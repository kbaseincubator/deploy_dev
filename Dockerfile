# Dockerfile that builds a minimal container for IPython + narrative
#
# Copyright 2013 The Regents of the University of California,
# Lawrence Berkeley National Laboratory
# United States Department of Energy
# The DOE Systems Biology Knowledgebase (KBase)
# Made available under the KBase Open Source License
#

# The base image "kbase/deplbase" to this Dockerfile has ONBUILD instructions that
# are executed when this image "kbase/depl" is build. This is why this 
# Dockerfile seems to be empty.

FROM kbase/deplbase:latest
MAINTAINER Shane Canon scanon@lbl.gov



