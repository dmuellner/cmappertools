#!/usr/bin/env bash

set -e -x

# Install Boost, -y means "assume yes".
yum -y install boost148-thread boost148-devel
#yum -y install yum-utils
#repoquery --list boost148-python
if test -f /usr/lib/libboost_thread-mt.so.1.48.0; then
    ln -s /usr/lib/libboost_thread-mt.so.1.48.0 /usr/lib/boost148/libboost_thread.so
fi
if test -f /usr/lib64/libboost_thread-mt.so.1.48.0; then
    ln -s /usr/lib64/libboost_thread-mt.so.1.48.0 /usr/lib64/boost148/libboost_thread.so
fi

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp27"* ]] || \
       [[ "${PYBIN}" == *"cp35"* ]] || \
       [[ "${PYBIN}" == *"cp36"* ]] || \
       [[ "${PYBIN}" == *"cp37"* ]] || \
       [[ "${PYBIN}" == *"cp38"* ]]; then
        "${PYBIN}/pip" install numpy
        echo '''[build_ext]
include_dirs=/usr/include/boost148
library_dirs=/usr/lib/boost148:/usr/lib64/boost148
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
