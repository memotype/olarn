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
  size: size;
  tileset: Tileset.t;
  grid: Tileset.tile array;
}

let make (w, h) tileset = {
  size = {w; h};
  tileset = tileset;
  grid = Array.make (w * h) tileset.tiles.(0);
}

let get g (x, y) =
  g.grid.(g.size.w * y + x)

let set g tile (x, y) =
  g.grid.(g.size.w * y + x) <- tile

let fill_area g tile (x1, y1) (x2, y2) =
  for x = x1 to x2 do
    for y = y1 to y2 do
      g.grid.(g.size.w * y + x) <- tile
    done
  done

let fill g tile =
  fill_area g tile (0, g.size.w) (0, g.size.h)
