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
open Util


let render_layers rend layers =
  List.iter (View.render rend) layers


let rec event_loop rend layers =
  (* Main event loop *)
  let event = Sdl.Event.create () in
  let rec event_loop_inner () =
    check_err (Sdl.wait_event (Some event));
    log "%a" Fmts.pp_event event;
    match Sdl.Event.(enum (get event typ)) with
    | `Quit -> ()
    | `Drop_file ->
      Sdl.Event.drop_file_free event;
      event_loop_inner ()
    | _ ->
      render_layers rend !layers;
      event_loop rend layers
  in event_loop_inner ()


let main () =
  let win = Window.init (639, 480) in
  let rend = Window.get_renderer win in
  Sdl.set_render_draw_color rend 0 0 0 255 |> check_err;
  Sdl.render_clear rend |> check_err;
  Sdl.render_present rend;
  Sdl.start_text_input ();
  let layers 
    : View.t list ref 
    = ref [] in
  event_loop rend layers;
  Window.quit win
