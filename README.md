flora
===

This R package includes functions to query the Brazilian Flora Checklist.

## Developer

+ [Gustavo Carvalho](https://github.com/gustavobio)

## Data

The dataset included in the package was kindly made available by the [Brazilian Flora Checklist](http://floradobrasil.jbrj.gov.br), which is a joint effort by hundreds of taxonomists to provide an improved checklist of plants and fungae that occur in Brazil.

## Instalation

#### Install devtools and shiny

```coffee
install.packages("devtools")
install.packages("shiny")
library("devtools")
```

#### Install flora

```coffee
install_github("gustavobio/flora")
```

## Usage

The main function is `get.taxa`

```coffee
library(flora)
get.taxa(c("Miconia albicans", "Myrcia lingua", "Cofea arabica"))
```

```coffee
     id               scientific.name accepted.name          family taxon.rank taxon.status
1  9668 Miconia albicans (Sw.) Triana          <NA> Melastomataceae    species     accepted
2 10699 Myrcia guianensis (Aubl.) DC.          <NA>       Myrtaceae    species     accepted
3 24410             Coffea arabica L.          <NA>       Rubiaceae    species     accepted
         search.str            notes  original.search
1  Miconia albicans                  Miconia albicans
2 Myrcia guianensis replaced synonym    Myrcia lingua
3    Coffea arabica   was misspelled    Cofea arabica
```

There are several arguments to `get.taxa`. For instance, you can get the states of Brazil where the taxa occur:

```coffee
get.taxa(c("Miconia albicans", "Myrcia lingua", "Cofea arabica"), states = TRUE)
```

```coffee
     id               scientific.name accepted.name          family taxon.rank taxon.status
1  9668 Miconia albicans (Sw.) Triana          <NA> Melastomataceae    species     accepted
2 10699 Myrcia guianensis (Aubl.) DC.          <NA>       Myrtaceae    species     accepted
3 24410             Coffea arabica L.          <NA>       Rubiaceae    species     accepted
         search.str            notes  original.search
1  Miconia albicans                  Miconia albicans
2 Myrcia guianensis replaced synonym    Myrcia lingua
3    Coffea arabica   was misspelled    Cofea arabica
                                                                  occurrence
1 PB;GO;MG;RJ;AC;RR;RO;ES;PR;SP;AM;AP;PA;MS;TO;AL;SE;CE;BA;DF;MA;RN;PI;PE;MT
2                      PE;GO;MS;MT;AC;AM;AP;PA;AL;BA;CE;RN;RS;SC;ES;MG;RJ;SP
3                         GO;PR;SC;RS;ES;MG;RJ;MS;DF;SE;PE;CE;SP;PB;BA;AL;AC
```

Other arguments include `life.form`, `habitat`, `vernacular`, and `establishment`.

`get.taxa` will automaticaly fix misspelled names when possible, but you can also use `suggest.names` for that:

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
```coffee

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

You may also search for a species using vernacular names:

```coffee
vernacular("Pimenta", exact = TRUE)
```

```
      id             search.str          family vernacular.name     locality
1   7697 Erythroxylum daphnites Erythroxylaceae         pimenta Minas Gerais
2 110560   Xylopia brasiliensis      Annonaceae         Pimenta         <NA>
3 110583        Xylopia sericea      Annonaceae         Pimenta         <NA>
```

## Web application

There is a web application included where one can simply paste names into a textbox and get taxonomic information, links to the original data source, search within the results and export to a csv file.

```
web.tpl()
```
*Click the screenshot for a larger view*
![](http://i.imgur.com/Kjbb9nx.png)