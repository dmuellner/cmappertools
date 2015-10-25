#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import numpy
if sys.hexversion < 0x03000000: # uniform unicode handling for both Python 2.x and 3.x
    def u(x):
        return x.decode('utf-8')
    def textfileopen(filename):
        return open(filename, mode='r')
else:
    def u(x):
        return x
    def textfileopen(filename):
        return open(filename, mode='r', encoding='utf_8')

#import distutils.debug
#distutils.debug.DEBUG = 'yes'
from setuptools import setup, Extension

with textfileopen('cmappertools.cpp') as f:
    for line in f:
        if line.find('static char const __version__')==0:
            version = line.split('"')[1].split('"')[0]
            break

print('Version: ' + version)

if sys.platform.startswith('win32'):
    libraries = []
    extra_compile_args = ['/EHsc']
elif sys.platform.startswith('darwin'):
    libraries = ['boost_thread-mt', 'boost_chrono-mt']
    extra_compile_args = []
else:
    libraries = ['boost_thread', 'boost_chrono']
    extra_compile_args = []

setup(name='cmappertools',
      version=version,
      provides=['cmappertools'],
      description=('Optional helper module for the Python Mapper package '
                   'with fast, parallel C++ algorithms.'),
      long_description=('This is a companion package to `Python Mapper '
                        '<http://pypi.python.org/pypi/mapper>`_. '
                        'It contains the optional helper module '
                        'with fast, parallel C++ algorithms.'),
      ext_modules=[Extension(
          'cmappertools',
          ['cmappertools.cpp'],
          language='c++',
          libraries=libraries,
          extra_compile_args=extra_compile_args,
          include_dirs=[numpy.get_include()],
      )],
      keywords=['Mapper', 'Topological data analysis', 'TDA'],
      author=u("Daniel Müllner"),
      author_email="daniel@danifold.net",
      license="GPLv3 <http://www.gnu.org/licenses/gpl.html>",
      classifiers = [
          "Topic :: Scientific/Engineering :: Information Analysis",
          "Topic :: Scientific/Engineering :: Artificial Intelligence",
          "Topic :: Scientific/Engineering :: Bio-Informatics",
          "Topic :: Scientific/Engineering :: Mathematics",
          "Topic :: Scientific/Engineering :: Visualization",
          "Programming Language :: Python",
          "Programming Language :: Python :: 2",
          "Programming Language :: Python :: 3",
          "Programming Language :: C++",
          "Operating System :: OS Independent",
          "License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
          "Intended Audience :: Science/Research",
          "Development Status :: 5 - Production/Stable"
      ],
      url = 'http://danifold.net',
)
