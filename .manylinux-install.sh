#!/usr/bin/env bash

set -e -x

# Install Boost, -y means "assume yes".
yum -y install boost148-thread boost148-devel

#yum info boost148-python
#yum -y install yum-utils
#repoquery --list boost148-devel

ls -la /usr/include/boost148/boost/python

pwd
ls -la .

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp27"* ]] || \
       [[ "${PYBIN}" == *"cp35"* ]] || \
       [[ "${PYBIN}" == *"cp36"* ]] || \
       [[ "${PYBIN}" == *"cp37"* ]] || \
       [[ "${PYBIN}" == *"cp38"* ]]; then
        "${PYBIN}/pip" install numpy
        ls -la /io
        echo '''[build_ext]
include_dirs=/usr/include/boost148
''' > /io/setup.cfg
        "${PYBIN}/pip" install -e /io/
    (cd /io && "${PYBIN}/python" setup.py test)
        "${PYBIN}/pip" wheel /io/ -w dist/
        rm -rf /io/build /io/*.egg-info
    fi
done

# Bundle external shared libraries into the wheels
for whl in dist/cmappertools*.whl; do
    auditwheel repair "$whl" -w /io/dist/
done
