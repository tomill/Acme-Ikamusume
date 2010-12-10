#!/bin/sh

/usr/local/libexec/mecab/mecab-dict-index \
    -d /usr/local/lib/mecab/dic/ipadic \
    -f utf-8 -t utf-8 \
    -u share/ika.dic \
    dat/ika.csv;
