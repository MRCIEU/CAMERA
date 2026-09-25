docs:
    Rscript -e "devtools::document()"
check: docs
    Rscript -e "devtools::check()"
test:
    Rscript -e "devtools::test()"
install: docs
    Rscript -e "devtools::install(build_vignettes = TRUE)"
dev:
    Rscript -e "pak::local_install_dev_deps()"

# Rebuild the pkgdown site
# On macOS the "CAMeRa.html" redirect overwrites the CAMERA class page (same file on a case-insensitive file system), so rebuild that page
site:
    Rscript -e "unlink(c('vignettes/tutorial_cache', 'vignettes/import-local_cache'), recursive = TRUE)" \
        -e "pkgdown::build_site()" \
        -e "if (Sys.info()[['sysname']] == 'Darwin') { file.remove('docs/reference/CAMERA.html'); pkgdown::build_reference(topics = 'CAMERA') }"
