
open Tsdl
open Util

type t = {
  window : Sdl.window;
  renderer : Sdl.renderer;
}

let init (w, h) =
  let inits = Sdl.Init.(video + events) in
  check_err (Sdl.init inits);
  let flags = Sdl.Window.(shown + mouse_focus + resizable) in
  let window = check_err (Sdl.create_window ~w:w ~h:h "SDL events" flags) in
  let flags = Sdl.Renderer.presentvsync in
  match Sdl.create_renderer ~flags window with
  | Error (`Msg e) -> log_err " Create renderer: %s" e; None
  | Ok renderer -> Some {window; renderer}

let get_window win =
  win.window

let get_renderer win =
  win.renderer

let quit win =
  Sdl.destroy_window win.window;
  Sdl.quit ();
  exit 0
