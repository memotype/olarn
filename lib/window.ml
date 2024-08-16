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

open Tsdl
open Tsdl_image
open Util

type t = {
  window: Sdl.window;
  renderer: Sdl.renderer;
  image: Image.Init.t;
  layers: View.t list ref;
}

let init (w, h) =
  let inits = Sdl.Init.(video + events) in
  Sdl.init inits |> check_err;
  let img_inits = Image.Init.(jpg + png + tif + webp) in
  let image = Image.init img_inits in
  let flags = Sdl.Window.(shown + mouse_focus + resizable) in
  let window = check_err (Sdl.create_window ~w:w ~h:h "SDL events" flags) in
  let flags = Sdl.Renderer.presentvsync in
  let renderer = Sdl.create_renderer ~flags window |> check_err in
  let layers = [] in
  {window; renderer; image; layers}

let get_window win =
  win.window

let get_renderer win =
  win.renderer

let quit win =
  Sdl.destroy_window win.window;
  Sdl.quit ();
  exit 0

let add_layer win layer =
  win.layers := List.append win.layers [layer];

(* later
let insert_layer win layer =
  win.layers := 
*)
