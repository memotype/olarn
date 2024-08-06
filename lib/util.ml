(* Copyright (C) 2024 Isaac Freeman <memotype@gmail.com>
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *         http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *)

let log fmt = Format.printf (fmt ^^ "@.")
let log_err fmt = Format.eprintf (fmt ^^ "@.")

let check_err res = match res with
  | Error (`Msg e) -> log_err " * Error: %s" e; exit 1
  | Ok r -> r
