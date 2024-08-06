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
open Olarn
open Util

let event_loop rend =
  Sdl.set_render_draw_color rend 0 0 0 255 |> check_err;
  Sdl.render_clear rend |> check_err;
  Sdl.render_present rend;
  let e = Sdl.Event.create () in
  let rec loop () = 
    check_err (Sdl.wait_event (Some e));
    log "%a" Fmts.pp_event e;
    match Sdl.Event.(enum (get e typ)) with
    | `Quit -> ()
    | `Drop_file -> Sdl.Event.drop_file_free e; loop ()
    | _ -> loop ()
  in
  Sdl.start_text_input ();
  loop ()

let main () =
  let win = Window.init (640, 480) in
  let rend = Window.get_renderer win in
  event_loop rend;
  Window.quit win

let () = main ()
