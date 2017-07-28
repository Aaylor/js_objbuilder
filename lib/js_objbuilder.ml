(******************************************************************************)
(* MIT License                                                                *)
(*                                                                            *)
(* Copyright (c) 2017 Runarvot Loïc                                           *)
(*                                                                            *)
(* Permission is hereby granted, free of charge, to any person obtaining a    *)
(* copy of this software and associated documentation files (the "Software"), *)
(* to deal in the Software without restriction, including without limitation  *)
(* the rights to use, copy, modify, merge, publish, distribute, sublicense,   *)
(* and/or sell copies of the Software, and to permit persons to whom the      *)
(* Software is furnished to do so, subject to the following conditions:       *)
(*                                                                            *)
(* The above copyright notice and this permission notice shall be included in *)
(* all copies or substantial portions of the Software.                        *)
(*                                                                            *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *)
(* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *)
(* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        *)
(* DEALINGS IN THE SOFTWARE.                                                  *)
(******************************************************************************)

type 'a t = (string * Js.Unsafe.any) list

let empty = []

let i fn elt =
  Js.Unsafe.inject (fn elt)


(* Basic values *)

let push key translate value acc =
  match value with
  | None -> acc
  | Some value -> (key, translate value) :: acc

let push_bool key value acc =
  push key (i Js.bool) value acc

let push_float key value acc =
  push key (i Js.float) value acc

let push_int key value acc =
  push key (fun x -> Js.Unsafe.inject x) value acc

let push_string key value acc =
  push key (i Js.string) value acc


(* Optional values *)

let push_option key translate ovalue acc =
  match ovalue with
  | None -> acc
  | Some None -> push key Js.Unsafe.inject (Some Js.null) acc
  | Some Some s -> push key translate (Some s) acc

let push_obool key ovalue acc =
  push_option key (i Js.bool) ovalue acc

let push_ofloat key ovalue acc =
  push_option key (i Js.float) ovalue acc

let push_oint key ovalue acc =
  push_option key (fun x -> Js.Unsafe.inject x) ovalue acc

let push_ostring key ovalue acc =
  push_option key (i Js.string) ovalue acc


(* Composition *)

let compose x f = f x

let ( ++ ) = compose


(* Translater *)

external to_list: 'a t -> 'a t = "%identity"

let to_array t = Array.of_list t

let to_js t = Js.Unsafe.obj (to_array t)
