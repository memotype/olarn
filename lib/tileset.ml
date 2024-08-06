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

open Util

type t = {
  surface: Sdl.surface;
  tilesize: {x: int, y: int};
  tilesetsize: {x: int, y: int};
}

let load dirname =
  let tileset_conffile = Filesystem.concat dirname "tileset.toml" in
  let tileset_conf = Toml.Parser.from_file tileset_conffile in
  let (tilesize_x, tilesize_y) =
    begin match Toml.Table.find (Toml.key "tilesize") tileset_conf
                |> Toml.to_int_array
      with
      | x :: y :: [] -> (x, y)
      | _ -> log_err "Couldn't read tilesize from %s" tileset_conffile
    end
  in
  {
    surface: Sdl.



