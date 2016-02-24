# tests for get.taxa() in flora
context("get.taxa()")

miconia_albicans <- get.taxa("Miconia albicans")
myrcia_lingua <- get.taxa("Myrcia lingua")

test_that("get.taxa returns the expected classes", {
  expect_is(miconia_albicans, "data.frame")
  expect_is(myrcia_lingua, "data.frame")
})

test_that("get.taxa returns the expected values for accepted names", {
  expect_equal(miconia_albicans$id, 9668)
  expect_match(miconia_albicans$scientific.name, "Miconia albicans")
  expect_equal(miconia_albicans$family, "Melastomataceae")
  expect_equal(miconia_albicans$taxon.rank, "species")
  expect_equal(miconia_albicans$taxon.status, "accepted")
  expect_equal(miconia_albicans$search.str, "Miconia albicans")
  expect_equal(miconia_albicans$original.search, "Miconia albicans")
})

test_that("get.taxa returns the expected values for synonyms", {
  expect_equal(myrcia_lingua$id, 10699)
  expect_match(myrcia_lingua$scientific.name, "Myrcia guianensis")
  expect_equal(myrcia_lingua$family, "Myrtaceae")
  expect_equal(myrcia_lingua$taxon.rank, "species")
  expect_equal(myrcia_lingua$taxon.status, "accepted")
  expect_equal(myrcia_lingua$threat.status, "LC")
  expect_equal(myrcia_lingua$search.str, "Myrcia guianensis")
  expect_equal(myrcia_lingua$notes, "replaced synonym")
  expect_equal(myrcia_lingua$original.search, "Myrcia lingua")
})