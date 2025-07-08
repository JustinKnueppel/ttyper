open Minttea

type state = {
  words : string list;
  typed_rev : string list; (* *)
  stop : bool;
}

let rec join sep = function
    | [] -> ""
  | [s] -> s
  | s::tl -> s ^ sep ^ join sep tl

let init _ = Command.Noop

let initial_model = {
  words = String.fold_left (fun acc c -> String.make 1 c :: acc) [] "hello world" |> List.rev;
  typed_rev = [];
  stop = false;
}

let update event model = 
  match event with
  | Event.KeyDown (Event.Escape, _) -> ({model with stop = true}, Command.Quit)
      | Event.KeyDown (Event.Backspace, _mod) -> ({model with typed_rev = List.drop 1 model.typed_rev}, Command.Noop)
  | Event.KeyDown (Event.Key key, _mod) -> ({model with typed_rev = key :: model.typed_rev }, Command.Noop)
  | Event.KeyDown (Event.Space, _mod) -> ({model with typed_rev = " " :: model.typed_rev }, Command.Noop)
  | _ -> (model, Command.Noop)

let view model =
  if model.stop then Format.sprintf "Typed %d characters" @@ List.length model.typed_rev
  else Format.sprintf "%s\n\n%s" (join "" model.words) (join "" @@ List.rev model.typed_rev)

let () = Minttea.app ~init ~update ~view () |> Minttea.start ~initial_model
