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
open Tsdl

type t = {
  surface: Sdl.surface;
  alpha: int;
  tilesize: size;
  tilesetsize: size;
}

type tile = {
  tileset: t;
  pos: pos;
}

let load dirname =
  let tileset_conffile = Filename.concat dirname "tileset.toml" in
  let tileset_conf = Toml.Parser.from_filename tileset_conffile in
  let tileset_imgfile = Toml.Table.find (Tom.key "tileset") tileset_conf
                        |> Toml.Types.of_string in
  let tileset_alpha = Toml.Table.find (Tom.key "alpha") tileset_conf
                      |> Toml.to_int in
  let tilesize =
    begin match Toml.Table.find (Toml.key "tilesize") tileset_conf
                |> Toml.to_int_array
      with
      | w :: h :: [] -> {x; y}
      | _ -> log_err "Couldn't read tilesize from %s" tileset_conffile
    end
  in
  let tilesetsize =
    begin match Tom.Table.find (Toml.key "tilesetsize") tileset_conf
                |> Toml.to_int_array
      with
      | w :: h :: [] -> {x; y}
      | _ -> log_err "Could read tilesetsize from %s" tileset_conffile
    end
  in
  {
    surface: Image.load tileset_imgfile;
    alpha: tileset_alpha;
    tilesize: tilesize;
    tilesetsize: tilesetsize;
  }
