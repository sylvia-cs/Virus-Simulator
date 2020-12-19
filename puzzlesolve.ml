(*
                         CS 51 Problem Set 6
                                Search
                            Puzzle Solving
  This file contains the PUZZLESOLVER signature for modules that solve
  particular puzzles, as well as a higher-order functor,
  MakePuzzleSolver. A PUZZLESOLVER module solves the puzzle by searching
  for a path from the initial state to the goal state.
  The MakePuzzleSolver functor takes a COLLECTION functor and a
  PUZZLEDESCRIPTION and returns a PUZZLESOLVER. The collection specified
  by the functor is used to store the states that have been reached so
  far. Thus, the ordering in which states are delivered by the
  collection (with the take function) determines the order in which the
  states are searched. A stack regime gives depth-first search, a queue
  regime breadth-first search.
  At the bottom of the file are definitions for depth-first search and
  breadth-first search puzzle solvers, partially applied versions of the
  MakePuzzleSolver functor that use certain collections to engender
  different search methods.
  This file makes use of the Set and Collections module, as well as
  the PuzzleDescription module (which it opens).
 *)

open Puzzledescription

(* PUZZLESOLVER -- a module signature that provides for solving puzzles
   and graphically drawing the results *)

module type PUZZLESOLVER =
  sig
    (* CantReachGoal -- Exception raised by solver when no solution can
       be found *)
    exception CantReachGoal

    (* state -- The possible puzzle states *)
    type state
    (* move -- The possible moves *)
    type move

    (* solve () -- Returns a solution to the puzzle as a pair containing
       a list of moves and a list of states. The moves, when executed
       starting in the initial state, result in a goal state. A list
       of all of the states visited in the solution process in order
       of visiting (useful in visualizing the search process) is
       provided as the returned state list. *)
    val solve : unit -> move list * state list
    (* draw states moves -- Graphically renders a solution given by the
       `moves` that was discovered through visiting the `states` *)
    val draw : state list -> move list -> unit
    (* print_state state -- Prints a representation of `state` on the
       standard output *)
    val print_state : state -> unit
  end

(* MakePuzzleSolver -- a higher-order functor that generates puzzle
   solvers, with typelet
     (functor (sig type t end -> COLLECTION)) -> PUZZLEDESCRIPTION -> PUZZLESOLVER
   A functor that given a functor from an element type to a
   COLLECTION, as well as a PUZZLEDESCRIPTION, returns a full
   PUZZLESOLVER module.
   The functor MakeCollection is used for generating the collection
   for storing pending states that have yet to be searched. Using
   different collection regimes -- stacks (MakeStackList), queues
   (MakeQueueList, MakeQueueStack), etc. -- leads to different search
   regimes -- depth-first, breadth-first, etc.
 *)
module MakePuzzleSolver
         (MakeCollection
            : functor (Element : sig type t end) ->
                      (Collections.COLLECTION with type elt = Element.t))
         (G : PUZZLEDESCRIPTION)
       : (PUZZLESOLVER with type state = G.state
                        and type move = G.move) =
  struct

    exception CantReachGoal
    type state = G.state
    type move = G.move

    module Pending : (Collections.COLLECTION with type elt = state * (move list)) =
        MakeCollection (
          struct
            type t = state * (move list)
          end)

    module Visited : (Set.S with type elt = state) =
      Set.Make (
        struct
          type t = state
          let compare = G.compare_states
        end)

    let solve () : (move list * state list) =
      let pending = Pending.add (G.initial_state, []) (Pending.empty) in
      let visited = Visited.empty in

      let rec search (pend : Pending.collection) (visit : Visited.t) =
      if Pending.is_empty pend then raise CantReachGoal
      (* search current state *)
      else let ((current, lst), col) = Pending.take pend in
        if List.mem current (Visited.elements visit) then search col visit
        else let new_set = Visited.add current visit in
         (* check if goal *)
          if G.is_goal current then (lst, Visited.elements new_set)
          (* add neighbors *)
          else let new_neighbors = List.fold_left (fun acc el -> Pending.add el acc) pend
            (List.map (fun (new_state, m) -> (new_state, lst @ [m])) (G.neighbors current)) in
            search new_neighbors new_set in
      search pending visited

    let draw : state list -> move list -> unit = G.draw

    let print_state : state -> unit = G.print_state

  end ;;

(* DFSSolver and BFSSolver -- Higher-order functors that take in a
   PUZZLEDESCRIPTION, and will return puzzles that are solved with DFS and
   BFS, respectively. The fast bfs solver uses a better implementation
   of queues for speed. *)
module DFSSolver = MakePuzzleSolver (Collections.MakeStackList) ;;
module BFSSolver = MakePuzzleSolver (Collections.MakeQueueList) ;;
module FastBFSSolver = MakePuzzleSolver (Collections.MakeQueueStack) ;;
