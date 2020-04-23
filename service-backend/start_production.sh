#!/usr/bin/env bash

export RAILS_SERVE_STATIC_FILES=true && \
puma -e production -w 4 -p 8001
