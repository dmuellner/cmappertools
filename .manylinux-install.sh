#!/usr/bin/env bash

set -e -x

# Install Boost, -y means "assume yes".
yum -y install boost-thread boost-devel

# Compile wheels
for PYBIN in /opt/python/*/bin; do
    if [[ "${PYBIN}" == *"cp27"* ]] || \
       [[ "${PYBIN}" == *"cp35"* ]] || \
       [[ "${PYBIN}" == *"cp36"* ]] || \
       [[ "${PYBIN}" == *"cp37"* ]] || \
       [[ "${PYBIN}" == *"cp38"* ]]; then
        "${PYBIN}/pip" install numpy
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
