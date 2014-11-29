#! /bin/bash

begin='<script type="text\/javascript" src="http:\/\/cdn.mathjax.org\/mathjax\/latest\/MathJax.js?config=TeX-AMS-MML_HTMLorMML">'
end='<\/script>'
pos='<script src="\/js\/script.js" type="text\/javascript"><\/script>'

find ./public -name 'index.html' | xargs -I '{}' \
sed -i -e /"$begin"/,/"$end"/d -e "/^$pos/a$begin$end" '{}'

