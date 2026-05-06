# Archivo: setup.py
from setuptools import setup
from Cython.Build import cythonize

setup(
    name='Modulo Montecarlo',
    # cythonize traduce el .pyx a .c y luego llama a GCC
    ext_modules=cythonize("montecarlo.pyx", language_level="3")
)
