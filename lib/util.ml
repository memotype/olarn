let log fmt = Format.printf (fmt ^^ "@.")
let log_err fmt = Format.eprintf (fmt ^^ "@.")

let check_err res = match res with
  | Error (`Msg e) -> log_err " * Error: %s" e; exit 1
  | Ok r -> r
