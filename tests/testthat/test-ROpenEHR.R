source("../../R/ROpenEHR.R", chdir = TRUE)
library(testthat)
library(httr)

test_that("query_validRequest_returnsDataFrame ", {
  aql <- "SELECT
 c/archetype_details/archetype_id/value as sourcearchetype,
 c/archetype_details/template_id/value as templateid,
 c/content[openEHR-EHR-ADMIN_ENTRY.rettslig_grunnlag.v1]/data[at0001]/items[at0025]/value/value as underTPHsiden,
 c/content[openEHR-EHR-ADMIN_ENTRY.rettslig_grunnlag.v1]/data[at0001]/items[at0031]/value/value as vedtakGjelderTil,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[openEHR-EHR-CLUSTER.hjemmel.v1]/items[at0020]/value/defining_code/code_string as hjemmel_atkode,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[openEHR-EHR-CLUSTER.hjemmel.v1]/items[at0020]/value/value as hjemmel_tekst,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[at0004]/value/value as overforesTilEnhet,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[at0004]/value/mappings/target/code_string as overforesTilEnhetId,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[at0005]/value/defining_code/code_string as overforesTvangsform_atkode,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[at0005]/value/value as overforesTvangsform_tekst,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[at0010]/value/value as institusjonenOK,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[at0014]/value/defining_code/code_string as iverksettingOverforing_atkode,
 c/content[openEHR-EHR-ADMIN_ENTRY.vedtak_om_overforing_til_annen_institusjon.v1]/data[at0001]/items[at0014]/value/value as iverksettingOverforing_tekst
FROM COMPOSITION c"

  response <- aqlquery("https://vt-tb-a-f-2.dips.local:4443", aql)

  expect_equal(class(response), "data.frame")
})

test_that("aqlquery_fakeurl_returnsError", {
  expect_error(aqlquery("https://ABC123svt-tb-a-f-2.dips.local:4443", "123"), "Could not resolve host: ABC123svt-tb-a-f-2.dips.local")
})

test_that("query_notFound_returnsHTTPResponseWithStatusCode404", {
  response <- aqlquery("https://vt-tb-a-f-2.dips.local:4443/abc", "123")
  expect_true(status_code(response) == "404")
})





