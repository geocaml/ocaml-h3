(lang dune 3.14)

(name h3)

(generate_opam_files true)

(source
 (github mdales/ocaml-h3))

(authors "Travis Brady <travis.brady@gmail.com>" "Michael Dales <michael@digitalflapjack.com>")

(maintainers "Michael Dales <michael@digitalflapjack.com>")

(license "Apache V2")

(documentation https://github.com/mdales/ocaml-h3)

(package
 (name h3)
 (synopsis "An OCaml wrapper for the H3 geospatial library.")
 (description "A thin OCaml wrapper for Uber's H3 geospatial library system.")
 (depends ocaml alcotest)
 (tags
  (H3 geospatial)))
