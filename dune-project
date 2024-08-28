(lang dune 3.16)

(name olarn)

(generate_opam_files true)

(source
  (github memotype/olarn))

(authors "Isaac Freeman <memotype@gmail.com>")

(maintainers "Isaac Freeman <memotype@gmail.com>")

(license Apache-2.0)

;(documentation https://url/to/documentation)

(package
  (name olarn)
  (synopsis "A roguelike client/server engine")
  (description "A longer description")
  (depends ocaml dune tsdl tsdl-image capnp)
  (tags
    (topics "to describe" your project)))

(package
  (name olarn_server)
  (synopsis "A roguelike client/server engine")
  (description "A longer description")
  (depends ocaml dune capnp)
  (tags
    (topics "to describe" your project)))

(package
  (name olarnp)
  (synopsis "A roguelike client/server engine protocol")
  (description "A longer description")
  (depends ocaml dune capnp)
  (tags
    (topics "to describe" your project)))
