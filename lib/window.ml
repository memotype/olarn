
open Tsdl
open Util

module Window = struct

type t = {
  window : Sdl.window;
  renderer : Sdl.renderer;
}

let init (w, h) =
  let inits = Sdl.Init.(video + events) in
  match Sdl.init inits with
  | Error (`Msg e) -> Util.log_err " SDL init: %s" e; None
  | Ok () ->
      let flags = Sdl.Window.(shown + mouse_focus + resizable) in
      match Sdl.create_window ~w:w ~h:h "SDL events" flags with
      | Error (`Msg e) -> Util.log_err " Create window: %s" e; None
      | Ok window ->
          let flags = Sdl.Renderer.presentvsync in
          match Sdl.create_renderer ~flags window with
          | Error (`Msg e) -> Util.log_err " Create renderer: %s" e; None
          | Ok renderer -> Some {window; renderer}

let get_window win =
  win.window

let get_renderer win =
  win.renderer

let quit win =
  Sdl.destroy_window win.window;
  Sdl.quit ();
  exit 0

end
