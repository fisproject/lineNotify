context("notify_ggplot.R")

test_that("rand_strings() generates the correct number of characters", {
  expect_that(nchar(rand_strings()), equals(16))
  expect_that(nchar(rand_strings(1)), equals(1))
  expect_that(nchar(rand_strings(256)), equals(256))
  expect_that(nchar(rand_strings(0)), equals(16))
  expect_that(nchar(rand_strings(-1)), equals(16))
})
