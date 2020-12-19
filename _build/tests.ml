(*
                                CS 51
                        Problem Set 6: Search

                     Testing Tile and Maze Puzzles

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
open Tests_functions

(*......................................................................
                       SAMPLE TILE PUZZLE TESTING
*)

(* initialize to known seed for reproducibility *)
module TestTileII : TILEINFO =
  struct
    let dims = 3, 3
    let initial : board =
      [| [|Tile 1; Tile 2; Tile 3|];
         [|Tile 4; Tile 5; Tile 6|];
         [|Tile 7; Tile 8; EmptyTile|]; |]
  end

module TII  = TestTilePuzzle(TestTileII)

let _ =
  TII.test_tile_puzzle 15;
  TII.test_tile_puzzle 30;
  TII.test_tile_puzzle 45;;


(* Note that once the mazes get too big, the OCaml graphics module can't
   properly render them *)

module TestMazeI : MAZEINFO =
  struct
    let maze = square_maze 1 init_maze
    let initial_pos =  (0,0)
    let goal_pos = (4,4)
    let dims = (5, 5)
  end

module TestMazeII : MAZEINFO =
  struct
    let maze = square_maze 2 init_maze
    let initial_pos =  (0, 0)
    let goal_pos = (9, 9)
    let dims = (10, 10)
  end

module TestMazeIII : MAZEINFO =
  struct
    let maze = square_maze 3 init_maze
    let initial_pos = (0, 0)
    let goal_pos = (14, 14)
    let dims = (15, 15)
  end

(* Run the testing for each of our test mazes *)
module MI   = TestMazePuzzle (TestMazeI)
module MII  = TestMazePuzzle (TestMazeII)
module MIII = TestMazePuzzle (TestMazeIII)

let _ =
  MI.run_tests ();
  MII.run_tests ();
  MIII.run_tests ();
