(*
                             CS 51 Problem Set 4
                   A Language for Symbolic Mathematics
                                 Testing
 *)

open Collections ;;

let unit_test (condition : bool) (msg : string) : unit =
  if condition then
    Printf.printf "%s passed\n" msg
  else
    Printf.printf "%s FAILED\n" msg ;;

(* unit_test_within tolerance value1 value2 msg -- Tests that value1
   is within tolerance of value2. Identifies test using msg. *)
let unit_test_within (tolerance : float)
                     (value1 : float)
                     (value2 : float)
                     (msg : string)
                   : unit =
  unit_test (abs_float (value1 -. value2) < tolerance) msg ;;

module IntCol =
  struct
    type t = int
  end

module StrCol =
  struct
    type t = string
  end

(* test functor with ints *)

module IntQueueStack =
  MakeQueueStack (IntCol)

let x = IntQueueStack.empty ;;

open IntQueueStack ;;

let x1 = add 4 (add 3 (add 2 (add 1 x)));;
(* dequeue (flip stack) *)
let x2 = let (_h, t) = take x1 in t
(* enqueue (add to revrear stack) *)
let x3 = add 10 x2
(* empty front stack *)
let x4 = let (_h, t) = take x3 in t ;;
let y4 = let (h, _t) = take x3 in h ;; (* return 2 *)

let x5 = let (_h2, t2) = take x4 in t2 ;;
let y5 = let (h2, _t2) = take x4 in h2 ;; (* return 3 *)

let x6 = let (_h3, t3) = take x5 in t3 ;;
let y6 = let (h3, _t3) = take x5 in h3 ;; (* return 4 *)

let x7 = let (_h, t) = take x6 in t ;;
let y7 = let (h, _t) = take x6 in h ;; (* return 10 *)

(* test functor with strings *)

module StrQueueStack =
  MakeQueueStack (StrCol)

open StrQueueStack ;;

let a0 = StrQueueStack.empty ;;

let a = add "1" (add "5" (add "S" (add "C" a0)));;
(* dequeue (flip stack) *)
let b = let (_h, t) = take a in t
(* enqueue (add to revrear stack) *)
let c = add "pset6" b
(* empty front stack *)
let d = let (_h, t) = take c in t ;;
let d2 = let (h, _t) = take c in h ;; (* return "S" *)

let e = let (_h2, t2) = take d in t2 ;;
let e2 = let (h2, _t2) = take d in h2 ;; (* return "5" *)

let f = let (_h3, t3) = take e in t3 ;;
let f2 = let (h3, _t3) = take e in h3 ;; (* return "1" *)

let g = let (_h, t) = take f in t ;;
let g2 = let (h, _t) = take f in h ;; (* return "pset6" *)



let queue_stack_tests () =
  unit_test (y4 = 2)
            "IntQueueStack take front";
  unit_test (y5 = 3)
            "IntQueueStack take front";
  unit_test (y6 = 4)
            "IntQueueStack take front";
  unit_test (y7 = 10)
            "IntQueueStack take rear" ;
  unit_test (d2 = "S")
            "StrQueueStack take front";
  unit_test (e2 = "5")
            "StrQueueStack take front";
  unit_test (f2 = "1")
            "StrQueueStack take front";
  unit_test (g2 = "pset6")
            "StrQueueStack take rear" ;;

let test_empty () =
  let emp1 = empty in
    try
        let _ = take emp1 in assert false
    with
        Empty -> assert true ;

  let emp2 = g in
    try
        let _ = take emp2 in assert false
    with
        Empty -> assert true;;

let test_all () =
  queue_stack_tests () ;
  test_empty () ;;

let _ = test_all () ;;
