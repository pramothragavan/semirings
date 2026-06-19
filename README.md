# Semirings package for GAP

The Semirings package provides tools for enumerating semirings and related algebraic structures of small orders. The package allows users to count and generate semirings up to isomorphism or equivalence using a rudimentary algorithm and the library of small semigroups provided by Smallsemi. It supports a variety of structures and offers extensibility to custom constraints. This package fills a gap in the literature by providing the first known counts (in many cases) of semirings and their variants up to equivalence.

## Installing Semirings

Before installing Semirings, make sure that the following GAP packages are available:

* `Semigroups` version 4.5 or later;
* `Smallsemi` version 0.7.2 or later.

You will also need the usual build tools required for compiling GAP packages, including a working shell and `make`.

### Downloading and extracting the package

Download the latest Semirings archive from the [Semirings webpage](https://pramothragavan.github.io/semirings/), and move the archive into a `pkg` subdirectory used by your GAP installation. Then unpack the archive:

```sh
cd /path/to/gap/pkg
tar -xzf semirings-<version>.tar.gz
```

This should create a  `semirings` directory for the package.

### Compiling the package

Change into the extracted package directory and compile the package:

```sh
cd /path/to/gap/pkg/semirings
./configure && make
```

### Loading Semirings in GAP

Start GAP in the usual way and type:

```gap
LoadPackage("semirings");
```

## Issues

For questions, remarks, suggestions, and issues please use the [issue tracker](https://github.com/pramothragavan/semirings/issues).
