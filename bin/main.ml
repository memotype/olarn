open Tsdl
open Olarn
open Util

let event_loop rend =
  match Sdl.set_render_draw_color rend 0 0 0 255 with
  | Error (`Msg e) -> log_err " Sdl.set_render_draw_color: %s" e; ()
  | Ok () ->
    match Sdl.render_clear rend with
    | Error (`Msg e) -> log_err " Sdl.render_clear: %s" e; ()
    | Ok () ->
      Sdl.render_present rend;
      let e = Sdl.Event.create () in
      let rec loop () = match Sdl.wait_event (Some e) with
        | Error (`Msg e) -> log_err " Could not wait event: %s" e; ()
        | Ok () ->
          log "%a" Fmts.pp_event e;
          match Sdl.Event.(enum (get e typ)) with
          | `Quit -> ()
          | `Drop_file -> Sdl.Event.drop_file_free e; loop ()
          | _ -> loop ()
      in
      Sdl.start_text_input ();
      loop ()

let main () =
  match Window.init (640, 480) with
  | None -> log_err " main: failed to initialize window"
  | Some win ->
    (*let rend = Window.get_renderer win in*)
    event_loop win.renderer;
    Window.quit win

let () = main ()
