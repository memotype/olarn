(lang dune 3.16)

(name olarn)

(generate_opam_files true)

(source
  (github username/reponame))

(authors "Isaac Freeman <memotype@gmail.com>")

(maintainers "Isaac Freeman <memotype@gmail.com>")

(license Apache-2.0)

(documentation https://url/to/documentation)

(package
  (name olarn)
  (synopsis "A short synopsis")
  (description "A longer description")
  (depends ocaml dune tsdl)
  (tags
    (topics "to describe" your project)))


; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
