#!/bin/sh
exec erl \
    -pa ebin deps/*/ebin \
    -boot start_sasl \
    -sname my_mochiweb_dev \
    -s my_mochiweb \
    -s reloader
