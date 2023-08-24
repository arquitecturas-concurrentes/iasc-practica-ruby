#!/bin/bash
echo "Using Bash version ${BASH_VERSION}..."

END=5
RAND_REQ=5

echo "Starting requests"

for (( c=0; c<=$END; c++ ))
do
    content= curl -sS -I http://localhost:9292/io_bound
    echo "${content}" >> out.html
	sleep $[ ( $RANDOM % $RAND_REQ )  + 1 ]s
done
