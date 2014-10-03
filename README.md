anomalous-dimensions [![development status](http://img.shields.io/badge/status-final--release-green.svg)](http://www.sciencedirect.com/science/article/pii/S0370269399005523) [![version](http://img.shields.io/badge/version-8.0-lightgrey.svg)](http://www.field-theory.org) [![platform](http://img.shields.io/badge/platform-linux%7Csolaris%7Cmacos-lightgrey.svg)](http://www.field-theory.org)
====================

Scientific software for computing the large order trend of the anomalous dimensions spectrum of trilinear twist - three quark operators. This software has been used for the paper reported in

[Large-order trend of the anomalous-dimensions spectrum of trilinear twist-3 quark operators, Phys.Lett. B458 (1999) 109-116](http://www.sciencedirect.com/science/article/pii/S0370269399005523)

Installation
------------

In order to reproduce the results in the publication you must have a C compiler and the GMP (Gnu Multiple Precision) library installed. The recommended version of the GMP library is v2.0.2, older version number will not work, higher versions have not been tested. For the final evaluation Mathematica v2.2 or higher is required.

The program has been tested on different Linux distributions with and Solaris systems. Compiling the C sources is done via

    ./configure
    make

If the GMP library is at a non-standard location, the appropriate flags can be added in the following manner (this is an example for GMP installed by [Fink](http://finkproject.org) on MacOS X):

    CFLAGS="-I/sw/include -L/sw/lib" ./configure
    CFLAGS="-I/sw/include -L/sw/lib" make

This will create the two executable files `ad_rat` and `ad_flt` which perform the calculation using exact arithmetics with rational polynomials and approximate arithmetics using high-precision floating point numbers, respectively.

Usage
-----

The physical background of the Bethe-Salpeter equation, relativistic bound states, evolution, and anomalous dimensions is discussed in the publication and references therein. The reader is assumed to be familiar with this background. For a review of the technical details of the calculation, please refer to the documentation contained in `doc/Technical.pdf`.

The numerically exact computation of the anomalous dimensions spectrum requires to take recourse to some suitable basis - we have decided to use Appell polynomials for this purpose since they turned out to be useful in analytic low-order calculations. When going to larger orders `N`, however, the coefficients of the polynomials will blow up and a numerical treatment has to take the huge numbers into account. Such a calculation can only be performed with high-precision arithmetics. After writing a Mathematica-based version, we decided to recode the algorithm in C using the GMP library which allowed for a huge speedup of the calculation.

Furthermore, the programs support a rather simple parallelization scheme which turned out to be very useful for calculations with orders becoming as large as `N=500`.

There are two different implementations of the algorithm: The first uses exact arithmetics, based on rational numbers. The second uses floating point arithmetics with a fixed, hardcoded precision. The numerical precision in the floating point version may have to be adjusted manually for larger orders, while the rational numbers version needs no adjustment. The former may, however, be significantly slower if the numerators and denominators become very large. Thus, for lower orders, the rational number version may be the method of choice, while for larger orders, the floating point version should be chosen.

We will demonstrate the different possibilities by an example: Compute the anomalous dimensions for the order `N=5`. The entire analysis with the rational numbers version will look as follows:

    ./ad_rat 5 1 3 rr.out rb.out
    math < Diagon_rat.m

The last line of the output from Mathematica will then contain the requested numbers:

    ...
    Out[21]= {-5.75609, -4.85758, -3.87204}

Using the floating point version is quite analogous

    ./ad_flt 5 1 3 rr.out rb.out
    math < Diagon_flt.m

The `ad_rat`/`ad_flt` programs have the following input parameters: The first is the order `N`, the second the starting row and the third the final row. The name of the output file containing the matrix is given by the fourth, and the solution vector by the fifth parameter.

By appropriate choices of the starting and final row, it is possible, to parallelize the program. We demonstrate this in the case of the `ad_flt` program:

    ./ad_flt 5 1 1 rr1 rb1
    ./ad_flt 5 2 2 rr2 rb2
    ./ad_flt 5 3 3 rr3 rb3
    cat rr1 rr2 rr3 > rr.out
    cat rb1 rb2 rb3 > rb.out
    math < Diagon_flt.m

This is useful if the individual jobs can be run on different machines. However, there is no automated control of the program flow and output files. Thus, for larger projects, it is advisable to use script files to avoid typing errors.

Remarks
-------

In particular in the case of the rational numbers version, the execution times for the individual rows may differ significantly. This has to do with the fact that the magnitude of the numbers depends on the row and hence the runtime for a row with large numbers in numerators and denominators will usually differ.

The accuracy for the floating point version `ad_flt` has been hardcoded into the program. It is sufficient to reproduce the results shown in the publication but may not suffice if still higher orders are requested. If this value turns out to be insufficient for your purposes, please adjust the value in the C source file `ad_flt.c.in`. Locate the line containing `#define ACCURACY X ...` and replace `X` by the desired accuracy in digits. A value of `X=800` turned out to be sufficient for orders `N<=500`. If you are only interested in rather small values of `N`, this number could probably be significantly reduced which should allow for some acceleration of the computation.

