
(*open Olarn.Fmts*)

module Util = struct

let log fmt = Format.printf (fmt ^^ "@.")
let log_err fmt = Format.eprintf (fmt ^^ "@.")

end
