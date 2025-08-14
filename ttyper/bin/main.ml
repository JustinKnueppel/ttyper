open Minttea

type screen = Init | Test | End | Quit

type state = {
  words : string list;
  typed_rev : string list; (* *)
  screen : screen
}

let rec join sep = function
    | [] -> ""
  | [s] -> s
  | s::tl -> s ^ sep ^ join sep tl

let init _ = Command.Enter_alt_screen

let initial_model = {
  words = String.fold_left (fun acc c -> String.make 1 c :: acc) [] "hello world" |> List.rev;
  typed_rev = [];
  screen = Init
}

let test_end words typed_rev = List.equal String.equal words @@ List.rev typed_rev

let update event model = 
  match event with
  | Event.KeyDown (Event.Enter, _mod) when model.screen = Init -> ({model with screen = Test}, Command.Noop)
  | Event.KeyDown (Event.Enter, _mod) when model.screen = Test -> ({model with screen = End}, Command.Noop)
  | Event.KeyDown (Event.Key "q", _mod) when model.screen = End -> ({model with screen = Quit}, Command.Quit)
  | Event.KeyDown (Event.Escape, _) -> ({model with screen = End}, Command.Exit_alt_screen)
      | Event.KeyDown (Event.Backspace, _mod) -> ({model with typed_rev = List.drop 1 model.typed_rev}, Command.Noop)
  | Event.KeyDown (Event.Key key, _mod) -> 
  let typed_rev = key :: model.typed_rev in
  let stop = if test_end model.words typed_rev then End else model.screen in
  let cmd = if stop = End then Command.Exit_alt_screen else Command.Noop in
    ({model with typed_rev = typed_rev ; screen = stop  }, cmd)
  | Event.KeyDown (Event.Space, _mod) -> ({model with typed_rev = " " :: model.typed_rev }, Command.Noop)
  | _ -> (model, Command.Noop)

let view model =
  match model.screen with
    | Init -> "Init"
    | Test -> Format.sprintf "%s\n\n%s" (join "" model.words) (join "" @@ List.rev model.typed_rev)
    | End -> Format.sprintf "Typed %d characters" @@ List.length model.typed_rev
    | Quit -> "Quit"

let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
