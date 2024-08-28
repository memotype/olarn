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
open Tsdl_image

type tile = {
  pos: pos;
}

type t = {
  surface: Sdl.surface;
  alpha: int;
  tiles: tile array;
  tilesize: size;
  tilesetsize: size;
}

let load dirname =
  let tileset_conffile = Filename.concat dirname "tileset.toml" in
  let tileset_conf = begin
    match Toml.Parser.from_filename tileset_conffile with
    | `Ok r -> r
    | `Error (m, l) -> failwith m
  end in
  let tileset_imgfile = begin
    match Toml.Types.Table.find (Toml.Min.key "tileset") tileset_conf with
    | Toml.Types.TString s -> s
    | _ ->
      log_err "Expected string for tileset value in %s" tileset_conffile;
      exit 1
  end in
  let tileset_alpha = begin
    match Toml.Types.Table.find (Toml.Min.key "alpha") tileset_conf with
    | Toml.Types.TInt i -> i
    | _ ->
      log_err "Expected int for alpha value in %s" tileset_conffile;
      exit 1
  end in
  let tilesize = begin
    match Toml.Types.Table.find (Toml.Min.key "tilesize") tileset_conf with
    | Toml.Types.TArray Toml.Types.NodeInt a -> begin
        match a with
        | w :: h :: [] -> {w; h}
        | _ ->
          log_err "Expected int array for tilesize value in %s" tileset_conffile;
          exit 1
      end
    | _ ->
      log_err "Expected int array for tilesize value in %s" tileset_conffile;
      exit 1
  end in
  let tilesetsize = begin
    match Toml.Types.Table.find (Toml.Min.key "tilesetsize") tileset_conf with
    | Toml.Types.TArray Toml.Types.NodeInt a -> begin
        match a with
        | w :: h :: [] -> {w; h}
        | _ ->
          log_err "Could read tilesetsize from %s" tileset_conffile;
          exit 1
      end
    | _ ->
      log_err "Could read tilesetsize from %s" tileset_conffile;
      exit 1
  end in
  let surface = begin
    match Image.load tileset_imgfile with
    | Ok i -> i
    | Error e ->
      log_err "Error loading image file %s" tileset_imgfile;
      exit 1
  end in
  let tiles =
    Array.init
      (tilesetsize.w * tilesetsize.h)
      (fun p ->
         {
           pos = {x = (p /   tilesetsize.w) * tilesize.w;
                  y = (p mod tilesetsize.h) * tilesize.h};
         })
  in
  {
    surface = surface;
    alpha = tileset_alpha;
    tiles = tiles;
    tilesize = tilesize;
    tilesetsize = tilesetsize;
  }
