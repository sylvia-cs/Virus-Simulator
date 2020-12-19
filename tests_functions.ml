(*
                                CS 51
                        Problem Set 6: Search

                      Shared Testing Functions

In this file, we provide some tests of the puzzle solver by generating
random tile and maze puzzles and running the various solving methods
(depth-first, breadth-first, etc.) on the examples. This code requires
working versions of the Collections and Puzzlesolve modules, so it won't
compile until you've completed those parts of the problem set. Once
those are done, however, you can build tests.byte and run it to watch
some puzzles being solved and get some timings. This will be useful in
designing your own experiments, as required in Problem 3 of the
problem set.  *)

open Absbook
open Tiles
open Mazes
open Puzzledescription
open Puzzlesolve

(*......................................................................
                       TILE PUZZLE TESTING
*)
(* TestTilePuzzle functor, returns a module that has one function (test_tile) *)
module TestTilePuzzle(T : TILEINFO) =
  struct

  let test_tile_puzzle (initial_moves : int) : unit =
(* rand_elt -- Return a random state out of a list returned by the
   neighbors function of a tile puzzle description *)
  let rand_elt l : board =
      fst (List.nth l (Random.int (List.length l))) in
(* random_tileboard -- Generate a random TileBoard by performing some
   random moves on the solved board *)
  let rec random_tileboard (n : int) (b : board) : board =
    let module G = MakeTilePuzzleDescription(T) in
      if n <= 0 then b
      else random_tileboard (n - 1) (rand_elt (G.neighbors b)) in
  (* Generate a puzzle with a random initial position *)
let module G =
  MakeTilePuzzleDescription (struct
                        let initial = random_tileboard initial_moves T.initial
                        let dims = T.dims
                        end) in

  Printf.printf("TESTING RANDOMLY GENERATING TILEPUZZLE...\n");
  (* Guarantee that the initial state is not the goal state *)
  assert (not (G.is_goal G.initial_state));

  (* Create some solvers *)
  let module DFSG = DFSSolver(G) in
  let module BFSG = BFSSolver(G) in
  let module FastBFSG = FastBFSSolver(G) in

  (* Run the solvers and report the results *)
  Printf.printf("Regular BFS time:\n");
  let (bfs_path, _bfs_expanded) = call_reporting_time BFSG.solve ()  in
  flush stdout;
  assert (G.is_goal (G.execute_moves bfs_path));

  Printf.printf("Faster BFS time:\n");
  let (fbfs_path, bfs_expanded) = call_reporting_time FastBFSG.solve ()  in
  (* For breadth first search, you should also check the length *)
  flush stdout;
  assert (G.is_goal (G.execute_moves bfs_path));
  assert (G.is_goal (G.execute_moves fbfs_path));
  assert (List.length fbfs_path = List.length bfs_path);
 (*
  Printf.printf("Depth First Searching\n");
  let dfs_path, dfs_expanded = call_reporting_time DFSG.solve () in
  flush stdout;
  DFSG.draw dfs_expanded dfs_path;
 *)
  Printf.printf("DONE TESTING TILE PUZZLE\n");

  (* Display the path found by one of the solvers *)
  BFSG.draw bfs_expanded bfs_path
end ;;

(*......................................................................
                      MAZE PUZZLE TESTING
*)

let init_maze = [|
    [| EmptySpace; EmptySpace; Wall; EmptySpace; EmptySpace|];
    [| Wall; EmptySpace; EmptySpace; EmptySpace; EmptySpace|];
    [| Wall; Wall; EmptySpace; Wall; EmptySpace|];
    [| EmptySpace; EmptySpace; EmptySpace; Wall; EmptySpace|];
    [| EmptySpace; Wall; EmptySpace; EmptySpace; EmptySpace|];
   |] ;;

let init_unsolvable = [|
    [| EmptySpace; Wall; Wall; Wall; Wall|];
    [| Wall; Wall; Wall; Wall; Wall|];
    [| Wall; Wall; Wall; Wall; Wall|];
    [| Wall; Wall; Wall; Wall; Wall|];
    [| Wall; Wall; Wall; Wall; EmptySpace|];
   |]

(* square_maze copies -- Given the 5 * 5 initial maze above, and a
   `ct` number of times to copy it, generates a maze that is of size
   `(5 * ct) x (5 * ct)`, with the initial maze tiled on it.
   Desperately seeking abstraction; DAISNAID. *)

let square_maze (copies : int) (init) : maze =
  let orig = 5 (* dimensions of original square maze *) in
  let new_maze = Array.make_matrix
                   (orig * copies) (orig * copies)
                   EmptySpace in
  let col_bound = (orig * copies) in
  let row_bound = (orig * copies) - orig in

  (* copy_maze -- tile the original maze into the new maze *)
  let rec copy_maze (crow: int) (ccol: int) (init) : maze =
    if (ccol = col_bound && crow = row_bound) then new_maze
    else if (ccol = col_bound) then
      copy_maze (crow + orig) 0 init
    else
      begin
        List.init orig Fun.id (* for each row *)
        |> List.iter (fun offset ->
                      Array.blit init.((crow + offset) mod orig) 0
                                 new_maze.(crow + offset) ccol orig);
        (* keep on recurring *)
        copy_maze (crow) (ccol + orig) init
      end in

  copy_maze 0 0 init ;;


(* TestMazePuzzle functor, returns a module that has one function (run_tests) *)
module TestMazePuzzle (M : MAZEINFO) =
  struct
    let run_tests () =
      (* Make a MazePuzzleDescription using the MAZEINFO passed in to our functor *)
      let module MPuzzle = MakeMazePuzzleDescription(M) in

      (* Generate three solvers -- two BFS solvers and a DFS solver *)
      let module DFSG = DFSSolver (MPuzzle) in
      let module FastBFSG = FastBFSSolver (MPuzzle) in
      let module BFSG = BFSSolver (MPuzzle) in
      Printf.printf("TESTING MAZE PUZZLE...\n");

      (* Solve the BFS maze and make sure that the path reaches the goal *)
      Printf.printf("Regular BFS time:\n");
      let (bfs_path, _bfs_expanded) = call_reporting_time BFSG.solve ()  in
      assert (MPuzzle.is_goal (MPuzzle.execute_moves bfs_path));

      (* Solve the BFS maze with the efficient queue and make sure the
         path reaches the goal *)
      Printf.printf("Fast BFS time:\n");
      let (fbfs_path, bfs_expanded) = call_reporting_time FastBFSG.solve ()  in
      assert (MPuzzle.is_goal (MPuzzle.execute_moves fbfs_path));

      (* Assert the length of the fast BFS and regular BFS path are the
         same, as BFS always finds the shortest path *)
      assert ((List.length fbfs_path) = (List.length bfs_path));

      (* Solve the DFS maze and make sure the path reaches the goal *)
      Printf.printf("DFS time:\n");
      let (dfs_path, dfs_expanded) = call_reporting_time DFSG.solve ()  in
      assert (MPuzzle.is_goal (MPuzzle.execute_moves dfs_path));

      Printf.printf("DONE TESTING MAZE PUZZLE, DISPLAYING MAZE NOW\n");
      BFSG.draw bfs_expanded bfs_path;
      DFSG.draw dfs_expanded dfs_path
  end ;;

(*......................................................................
                   UNSOLVABLE TILE PUZZLE TESTING
*)

(* functor generates modules with timing function *)
module TimeUnsolvable (P : PUZZLESOLVER) =
  struct
    let time () =
      let t0 = Unix.gettimeofday() in
      let _ =
        (try P.solve ()
          with P.CantReachGoal -> ([],[])) in
      let t1 = Unix.gettimeofday() in
      let time = (1000. *. (t1 -. t0)) in
        Printf.printf ("time (msecs): %f\n") time
  end ;;

(* times unsolvable tiles with all three search methods *)
module TestTileUnsolvable (T : TILEINFO) =
  struct
    let test_all_unsolvable () =
      let module P1 = BFSSolver(MakeTilePuzzleDescription(T)) in
      let module P2 = FastBFSSolver(MakeTilePuzzleDescription(T)) in
      let module P3 = DFSSolver(MakeTilePuzzleDescription(T)) in
      Printf.printf("TESTING UNSOLVABLE TILE...\n");

      let module T1 = TimeUnsolvable(P1) in
      let module T2 = TimeUnsolvable(P2) in
      let module T3 = TimeUnsolvable(P3)in

        Printf.printf("regular BFS time");
        T1.time ();
        Printf.printf("fast BFS time");
        T2.time ();
        Printf.printf("DFS time");
        T3.time ();
  end ;;

(*......................................................................
                   UNSOLVABLE MAZE PUZZLE TESTING
*)

(* times unsolvable mazes with all three search methods *)
module TestMazeUnsolvable (M : MAZEINFO) =
  struct
    let test_all_unsolvable () =
      let module P1 = BFSSolver(MakeMazePuzzleDescription(M)) in
      let module P2 = FastBFSSolver(MakeMazePuzzleDescription(M)) in
      let module P3 = DFSSolver(MakeMazePuzzleDescription(M)) in
      Printf.printf("TESTING UNSOLVABLE MAZE...\n");

      let module M1 = TimeUnsolvable(P1) in
      let module M2 = TimeUnsolvable(P2) in
      let module M3 = TimeUnsolvable(P3) in

        Printf.printf("regular BFS time");
        M1.time ();
        Printf.printf("fast BFS time");
        M2.time ();
        Printf.printf("DFS time");
        M3.time ();
  end ;;
