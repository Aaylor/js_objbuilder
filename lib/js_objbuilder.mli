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

(** This library allows to write javascript objects with optional values
    easier. *)

type 'a t
(** The type representation of an object builder.
    The ['a] type correspond to the result js object type. *)

val empty: _ t
(** The empty builder. *)


(** {2 Basic values} *)

val push: string -> ('a -> Js.Unsafe.any) -> 'a option -> 'b t -> 'b t
(** [push key translater ovalue acc] checks if the [ovalue] is set, and
    in this case use [translater] to store the value, associated with [key]
    to the builder [acc]. *)

val push_bool: string -> bool option -> 'a t -> 'a t
(** [push_bool key obool acc] pushes the boolean value to acc if it is set. *)

val push_float: string -> float option -> 'a t -> 'a t
(** [push_float key ofloat acc] pushes the float value to acc if it is set. *)

val push_int: string -> int option -> 'a t -> 'a t
(** [push_int key oint acc] pushes the int value to acc if it is set. *)

val push_string: string -> string option -> 'a t -> 'a t
(** [push_string key ostring acc] pushes the string value to acc if it is
    set. *)


(** {2 Optional values} *)

val push_option:
  string -> ('a -> Js.Unsafe.any) -> 'a option option -> 'b t ->
  'b t
(** [push_option key translater ovalue acc] is similar to [push], excepts
    that [Some None] is translated into the javascript [null] value. *)

val push_obool: string -> bool option option -> 'a t -> 'a t
(** [push_obool key obool acc] pushes the optional boolean value to acc. *)

val push_ofloat: string -> float option option -> 'a t -> 'a t
(** [push_ofloat key ofloat acc] pushes the optional float value to acc. *)

val push_oint: string -> int option option -> 'a t -> 'a t
(** [push_oint key oint acc] pushes the optional int value to acc. *)

val push_ostring: string -> string option option -> 'a t -> 'a t
(** [push_ostring key ostring acc] pushes the optional string value to acc. *)


(** {2 Composition} *)

val compose : 'a t -> ('a t -> 'a t) -> 'a t
(** [compose t1 fn] is similar to [fn t1]. *)

val ( ++ ) : 'a t -> ('a t -> 'a t) -> 'a t
(** [(++) t1 fn] is similar to [compose t1 t2]. *)


(** {2 Translation} *)

val to_list: 'a t -> (string * Js.Unsafe.any) list

val to_array : 'a t -> (string * Js.Unsafe.any) array

val to_js: 'a t -> 'a Js.t
