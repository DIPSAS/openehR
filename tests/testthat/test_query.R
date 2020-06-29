test_that("query_fakeurl_returnsError", {
  expect_error(
    query("https://ABC123svt-tb-a-f-2.dips.local:4443/openehr/v1", "123"),
    "Could not resolve host: ABC123svt-tb-a-f-2.dips.local"
  )
})

test_that("query_notFound_returnsHTTPResponseWithStatusCode404", {
  expect_error(query("https://vt-tb-a-f-2.dips.local:4443/abc", "123"))
})
