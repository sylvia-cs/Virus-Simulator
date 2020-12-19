(*
                         CS 51 Problem Set 6
                                Search

                             Collections

  The COLLECTION module signature is a generic data structure
  generalizing stacks, queues, and priority queues, allowing adding
  and taking elements. This file provides the signature and several
  functors implementing specific collections (stacks, queues,
  etc.).
 *)

module type COLLECTION =
sig

  (* Empty -- Exception indicates attempt to take from an empty
     collection *)
  exception Empty

  (* elements in the collection *)
  type elt

  (* collections themselves *)
  type collection

  (* empty -- the empty collection, collection with no elements *)
  val empty : collection

  (* length col -- Returns number of elements in the collection col *)
  val length : collection -> int

  (* is_empty col -- Returns true if and only if the collection col is
     empty *)
  val is_empty : collection -> bool

  (* add elt col -- Returns a collection like col but with an element
     elt added *)
  val add : elt -> collection -> collection

  (* take col -- Returns a pair of an element from the collection and
     the collection of the remaining elements; raises Empty if the
     collection is empty. Which element is taken is determined by the
     implementation. *)
  val take : collection -> elt * collection

end

(*----------------------------------------------------------------------
  Some useful collections

  To think about: For each of these implementations, what is the time
  complexity for adding and taking elements in this kind of
  collection?  *)

(*......................................................................
  Stacks implemented as lists
 *)

module MakeStackList (Element : sig type t end)
       : (COLLECTION with type elt = Element.t) =
  struct
    exception Empty

    type elt = Element.t
    type collection = elt list

    let empty : collection = []

    let is_empty (d : collection) : bool =
      d = empty

    let length (d : collection) : int =
      List.length d

    let add (e : elt) (d : collection) : collection =
      e :: d;;

    let take (d : collection) :  elt * collection =
      match d with
      | hd :: tl -> (hd, tl)
      | _ -> raise Empty
end

(*......................................................................
  Queues implemented as lists
 *)

module MakeQueueList (Element : sig type t end)
       : (COLLECTION with type elt = Element.t) =
  struct
    exception Empty

    type elt = Element.t
    type collection = elt list

    let empty : collection = []

    let length (d : collection) : int =
      List.length d

    let is_empty (d : collection) : bool =
      d = empty

    let add (e : elt) (d : collection) : collection =
      d @ [e];;

    let take (d : collection)  :  elt * collection =
      match d with
      | hd :: tl -> (hd, tl)
      | _ -> raise Empty
  end

(*......................................................................
  Queues implemented as two stacks

  In this implementation, the queue is implemented as a pair of stacks
  (s1, s2) where the elements in the queue from highest to lowest
  priority (first to last to be taken) are given by s1 @ s2R (where
  s2R is the reversal of s2). Elements are added (in stack regime) to
  s2, and taken from s1. When s1 is empty, s2 is reversed onto s1. See
  Section 15.2.2 in Chapter 15 for more information on this
  technique. *)

module MakeQueueStack (Element : sig type t end)
       : (COLLECTION with type elt = Element.t) =
  struct
    exception Empty

    type elt = Element.t
    type collection = (elt list * elt list)

    let empty : collection = ([], [])

    let is_empty (d : collection) : bool =
      d = empty

    let length ((front, revrear) : collection) : int =
      List.length front + List.length revrear

    let add (e : elt) ((front, revrear) : collection) : collection =
      front, e :: revrear

    let take ((front, revrear) : collection) :  elt * collection =
      match front with
      | [] -> (match List.rev revrear with
              | [] -> raise Empty
              | h :: t -> h, (t, []))
      | h :: t -> h, (t, revrear)

  end


(*======================================================================
Reflection on the problem set

After each problem set, we'll ask you to reflect on your experience.
We care about your responses and will use them to help guide us in
creating and improving future assignments.

........................................................................
Please give us an honest (if approximate) estimate of how long (in
minutes) this problem set (in total, not just this file) took you to
complete.
......................................................................*)

let minutes_spent_on_pset () : int =
  3000 ;;

(*......................................................................
It's worth reflecting on the work you did on this problem set, where
you ran into problems and how you ended up resolving them. What might
you have done in retrospect that would have allowed you to generate as
good a submission in less time? Please provide us your thoughts in the
string below.
......................................................................*)

let reflection () : string =
  "While the solve function was the most logically demanding aspect of" ^
  "this pset, the bulk of our time was spent designing, debugging, and " ^
  "running our experiments. Throughout this process, we encountered many" ^
  "small but critical issues, from not being able to run DFS on our tiles " ^
  "and needing to figure out how to time the runtime of unsolvable puzzles" ^
  "to properly abstracting our performance functions such that modules could" ^
  "be passed in from tests.ml and experiments.ml without any code duplication." ^
  "Much of this process required guessing and checking, running our code" ^
  "numerous times, and looking to examples for structuring our own performance" ^
  "measurement system. Our process could have been expedited had we cut out " ^
  "nonessential aspects (such as measuring runtime for unsolvable puzzles, and" ^
  "abstracting to the level that we did), but this process was extremely beneficial" ^
  "for us and ultimately led to quite interesting results."


