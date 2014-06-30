flora
=====

This is an R package that contains a set o functions to retrieve data the Brazilian Flora Checklist.

First, get devtools:

```
install.packages("devtools")
library(devtools)
```

Then, install the latest development version from github:

```
install_github("gustavobio/flora")
```

Usage is simple:

```
library(flora)
data(plants)
get.taxa(plants)
```

Alternatively, there is a web app:

```
web.flora()
```

All data is included in the package.
