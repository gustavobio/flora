# WARNING: The package is no long supported on CRAN. Both the database and the code are now outdated in their repository and should not be used. The only way to get the most recent version is from GitHub. Please follow the instructions below. There is a 5Mb limit to packages uploaded to CRAN. With recent inclusions, the database distributed within the package grew larger than that and CRAN administrators are not accepting my submissions.

flora
===

R package to query the Brazilian Flora 2020 dataset.

## Developer

+ [Gustavo Carvalho](https://github.com/gustavobio)

## Data

The dataset included in the package was kindly made available by the [Brazilian Flora 2020](http://floradobrasil.jbrj.gov.br), which is a joint effort by hundreds of taxonomists to provide an improved checklist of plants and fungi that occur in Brazil.

## Installation

#### Install devtools

```coffee
install.packages("devtools")
```

#### Install flora

```coffee
install_github("gustavobio/flora")
```

## Usage

The main function is `get.taxa`, which will fix misspelled names, replace synonyms, and get taxonomic information for a vector of names.

```coffee
library(flora)
get.taxa(c("Miconia albicans", "Myrcia lingua", "Cofea arabica"))
```

```coffee
     id               scientific.name accepted.name          family taxon.rank taxon.status
1  9668 Miconia albicans (Sw.) Triana          <NA> Melastomataceae    species     accepted
2 10699 Myrcia guianensis (Aubl.) DC.          <NA>       Myrtaceae    species     accepted
3 24410             Coffea arabica L.          <NA>       Rubiaceae    species     accepted
         search.str threat.status            notes  original.search
1  Miconia albicans          <NA>                  Miconia albicans
2 Myrcia guianensis            LC replaced synonym    Myrcia lingua
3    Coffea arabica          <NA>                    Coffea arabica
```

There are several arguments to `get.taxa`. For instance, you can get the domains in Brazil where the taxa occur:

```coffee
get.taxa(c("Miconia albicans", "Myrcia lingua", "Cofea arabica"), domain = TRUE)
```

```coffee
get.taxa(c("Miconia albicans", "Myrcia lingua", "Cofea arabica"), domain = TRUE)
     id               scientific.name accepted.name          family taxon.rank taxon.status        search.str threat.status
1  9668 Miconia albicans (Sw.) Triana          <NA> Melastomataceae    species     accepted  Miconia albicans          <NA>
2 10699 Myrcia guianensis (Aubl.) DC.          <NA>       Myrtaceae    species     accepted Myrcia guianensis            LC
3 24410             Coffea arabica L.          <NA>       Rubiaceae    species     accepted    Coffea arabica          <NA>
             notes  original.search                                   domain
1                  Miconia albicans Amazônia|Caatinga|Cerrado|Mata Atlântica
2 replaced synonym    Myrcia lingua Amazônia|Caatinga|Cerrado|Mata Atlântica
3   was misspelled    Cofea arabica Amazônia|Caatinga|Cerrado|Mata Atlântica
```

Other arguments include `life.form`, `habitat`, `vernacular`, `states`, and `establishment`.

`get.taxa` can automatically fix misspelled names when possible (when `suggest.names = TRUE`), but you can also use `suggest.names` for that:

```coffee
suggest.names("Cofea arabyca")
[1] "Coffea arabica"
```

If you have names with authors, you can try to remove them with `remove.authors`

```coffee
remove.authors("Symplocos phaeoclados var. acuminata Gontsch.")
[1] "Symplocos phaeoclados var. acuminata"
```

The function `lower.taxa` gets all names, accepted or not, which descends from a family or genus:

```coffee
lower.taxa("Rapanea")
```

```coffee
 [1] "Rapanea"              "Rapanea ferruginea"   "Rapanea gardneriana"  "Rapanea guianensis"  
 [5] "Rapanea leuconeura"   "Rapanea parvifolia"   "Rapanea umbellata"    "Rapanea venosa"      
 [9] "Rapanea intermedia"   "Rapanea oblonga"      "Rapanea perforata"    "Rapanea schwackeana" 
[13] "Rapanea congesta"     "Rapanea hermogenesii" "Rapanea lineata"      "Rapanea lancifolia"  
[17] "Rapanea loefgrenii"   "Rapanea quaternata"   "Rapanea matensis"     "Rapanea villicaulis" 
[21] "Rapanea villosissima" "Rapanea acuminata"    "Rapanea megapotamica" "Rapanea lorentziana" 
[25] "Rapanea laetevirens"  "Rapanea balansae"     "Rapanea emarginella"  "Rapanea glazioviana" 
[29] "Rapanea parvula"      "Rapanea squarrosa"    "Rapanea glaucorubens" "Rapanea ovalifolia"  
[33] "Rapanea umbrosa"      "Rapanea glomeriflora" "Rapanea oblongifolia" "Rapanea lauriformis" 
[37] "Rapanea depauperata"  "Rapanea paulensis"    "Rapanea wettsteinii" 
```

The function `get.synonyms` returns all synonyms of a given name:

```coffee
get.synonyms("Myrcia guianensis")
  [1] "Myrcia pallens"               "Myrcia torta"                 "Myrcia obtecta"               "Myrcia amethystina"          
  [5] "Myrcia corumbensis"           "Myrcia cymosa"                "Myrcia daphnoides"            "Myrcia decrescens"           
  [9] "Myrcia elaeodendra"           "Myrcia hepatica"              "Myrcia hiemalis"              "Myrcia intermedia"           
 [13] "Myrcia lingua"                "Myrcia microcarpa"            "Myrcia nigropunctata"         "Myrcia obtusa"               
 [17] "Myrcia rhabdoides"            "Myrcia rorida"                "Myrcia rubella"               "Myrcia suaveolens"           
 [21] "Myrcia angustifolia"          "Myrcia camapuana"             "Myrcia campestris"            "Myrcia collina"              
 [25] "Myrcia dermatophylla"         "Myrcia dictyophylla"          "Myrcia didrichseniana"        "Myrcia leucadendron"         
 [29] "Myrcia mansoi"                "Myrcia myoporina"             "Myrcia parnahibensis"         "Myrcia scrobiculata"         
 [33] "Myrcia vacciniifolia"         "Myrcia velhensis"             "Myrcianthes cymosa"           "Aguava guianensis"  
 ...
 [137] "Myrcia plumbea"               "Myrcia poeppigiana"           "Myrcia pusilla"               "Myrcia vattimoi" 
```

You can also return the relationships between names using `get.synonyms`:

```coffee
get.synonyms("Myrcia guianensis", relationship = T)
                  spp                      synonym                   relationship
1   Myrcia guianensis               Myrcia pallens Tem como sinônimo HETEROTIPICO
2   Myrcia guianensis                 Myrcia torta Tem como sinônimo HETEROTIPICO
3   Myrcia guianensis               Myrcia obtecta Tem como sinônimo HETEROTIPICO
4   Myrcia guianensis           Myrcia amethystina Tem como sinônimo HETEROTIPICO
5   Myrcia guianensis           Myrcia corumbensis Tem como sinônimo HETEROTIPICO
6   Myrcia guianensis                Myrcia cymosa Tem como sinônimo HETEROTIPICO
...
139 Myrcia guianensis               Myrcia pusilla Tem como sinônimo HETEROTIPICO
140 Myrcia guianensis              Myrcia vattimoi Tem como sinônimo HETEROTIPICO
```

You may also search for a species using vernacular names:

```coffee
vernacular("Pimenta", exact = T)
```

```coffee
      id             search.str          family vernacular.name     locality
1   7697 Erythroxylum daphnites Erythroxylaceae         pimenta Minas Gerais
2 110560   Xylopia brasiliensis      Annonaceae         Pimenta         <NA>
3 110583        Xylopia sericea      Annonaceae         Pimenta         <NA>
```

Smaller things like casing and missplaced whitespaces are also automatically fixed in `get.taxa`, but there are specific functions for those as well:

```coffee
fixCase("myrcia lingua")
[1] "Myrcia lingua"

trim("Myrcia    lingua   ")
[1] "Myrcia lingua"

standardize.names("Myrcia sp01")
[1] "Myrcia sp.1"

standardize.names("Myrcia sp2")
[1] "Myrcia sp.2"

standardize.names("Myrcia sp.3")
[1] "Myrcia sp.3"
```
