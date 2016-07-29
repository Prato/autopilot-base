#!/bin/sh

SERVICE_NAME=${SERVICE_NAME:-nginx}
CONSUL=${CONSUL:-consul}

help() {
    echo "Usage: manage.sh preStart  => first-run configuration for example app"
    echo "       manage.sh onChange  => [default] update example config on upstream changes"
}

preStart() {
    echo "preStart called by manage.sh"
    consul-template \
        -once \
        -dedup \
        -consul ${CONSUL}:8500 \
        -template "/etc/containerpilot/example.conf.ctmpl:/etc/example.conf"
}

onChange() {
    echo "onChange called by manage.sh, consul is: ${CONSUL}"
    consul-template \
        -once \
        -dedup \
        -consul ${CONSUL}:8500 \
        -template "/etc/containerpilot/example.conf.ctmpl:/etc/example.conf:cat /etc/example.conf"
}

health() {
    # write something specific to the app
    exit 0
}

preStop() {
    echo "preStop called by manage.sh"
    # anything that needs to be taken care of before this service instance is
    # stopped, this is the place
}

postStop() {
  echo "postStop called by manage.sh"
  # do something to clean up afterwards, perhaps
}

until
    cmd=$1
    if [ -z "$cmd" ]; then
        onChange
    fi
    shift 1
    $cmd "$@"
    [ "$?" -ne 127 ]
do
    onChange
    exit
done
