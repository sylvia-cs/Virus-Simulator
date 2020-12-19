(*
                                CS 51
                             Spring 2019
                        Problem Set 5: Search
                             Experiments
*)

open Absbook
open Tiles
open Mazes
open Puzzledescription
open Puzzlesolve
open Collections
open Tests_functions

(*......................................................................
                       2 x 2 TILE PUZZLE TESTING
*)

(* unsolvable tile modules *)

module TestTileIU : TILEINFO =
  struct
    let dims = 2, 2
    let initial : board =
      [| [|Tile ~-1; Tile 2|];
         [|Tile 3; EmptyTile|]; |]
  end

module TestTileIIU : TILEINFO =
  struct
    let dims = 3, 3
    let initial : board =
      [| [|Tile ~-1; Tile 2; Tile 3|];
         [|Tile 4; Tile 5; Tile 6|];
         [|Tile 7; Tile 8; EmptyTile|]; |]
  end

module TestTileIIIU : TILEINFO =
  struct
    let dims = 4, 4
    let initial : board =
      [| [|Tile ~-1; Tile 2; Tile 3; Tile 4|];
         [|Tile 5; Tile 6; Tile 7; Tile 8|];
         [|Tile 9; Tile 10; Tile 11; Tile 12|];
         [|Tile 13; Tile 14; Tile 15; EmptyTile|]; |]
end

module TestTileIVU : TILEINFO =
  struct
    let dims = 5, 5
    let initial : board =
      [| [|Tile ~-1; Tile 2; Tile 3; Tile 4; Tile 5|];
         [|Tile 6; Tile 7; Tile 8; Tile 9; Tile 10|];
         [|Tile 11; Tile 12; Tile 13; Tile 14; Tile 15|];
         [|Tile 16; Tile 17; Tile 18; Tile 19; Tile 20|];
         [|Tile 21; Tile 22; Tile 23; Tile 24; EmptyTile|]; |]
end

module TestTileVU : TILEINFO =
  struct
    let dims = 6, 6
    let initial : board =
      [| [|Tile ~-1; Tile 2; Tile 3; Tile 4; Tile 5; Tile 6|];
         [|Tile 7; Tile 8; Tile 9; Tile 10; Tile 11; Tile 12|];
         [|Tile 13; Tile 14; Tile 15; Tile 16; Tile 17; Tile 18|];
         [|Tile 19; Tile 20; Tile 21; Tile 22; Tile 23; Tile 24|];
         [|Tile 25; Tile 26; Tile 27; Tile 28; Tile 29; Tile 30|];
         [|Tile 31; Tile 32; Tile 33; Tile 34; Tile 35; EmptyTile|]; |]
end

(* solvable tile modules *)

module TestTileI : TILEINFO =
  struct
    let dims = 2, 2
    let initial : board =
      [| [|Tile 1; Tile 2|];
         [|Tile 3; EmptyTile|]; |]
  end

module TestTileII : TILEINFO =
  struct
    let dims = 3, 3
    let initial : board =
      [| [|Tile 1; Tile 2; Tile 3|];
         [|Tile 4; Tile 5; Tile 6|];
         [|Tile 7; Tile 8; EmptyTile|]; |]
  end

module TestTileIII : TILEINFO =
  struct
    let dims = 4, 4
    let initial : board =
      [| [|Tile 1; Tile 2; Tile 3; Tile 4|];
         [|Tile 5; Tile 6; Tile 7; Tile 8|];
         [|Tile 9; Tile 10; Tile 11; Tile 12|];
         [|Tile 13; Tile 14; Tile 15; EmptyTile|]; |]
end

module TestTileIV : TILEINFO =
  struct
    let dims = 5, 5
    let initial : board =
      [| [|Tile 1; Tile 2; Tile 3; Tile 4; Tile 5|];
         [|Tile 6; Tile 7; Tile 8; Tile 9; Tile 10|];
         [|Tile 11; Tile 12; Tile 13; Tile 14; Tile 15|];
         [|Tile 16; Tile 17; Tile 18; Tile 19; Tile 20|];
         [|Tile 21; Tile 22; Tile 23; Tile 24; EmptyTile|]; |]
end

module TestTileV : TILEINFO =
  struct
    let dims = 6, 6
    let initial : board =
      [| [|Tile 1; Tile 2; Tile 3; Tile 4; Tile 5; Tile 6|];
         [|Tile 7; Tile 8; Tile 9; Tile 10; Tile 11; Tile 12|];
         [|Tile 13; Tile 14; Tile 15; Tile 16; Tile 17; Tile 18|];
         [|Tile 19; Tile 20; Tile 21; Tile 22; Tile 23; Tile 24|];
         [|Tile 25; Tile 26; Tile 27; Tile 28; Tile 29; Tile 30|];
         [|Tile 31; Tile 32; Tile 33; Tile 34; Tile 35; EmptyTile|]; |]
end

(* modules with test_tile_puzzle function *)
module TI   = TestTilePuzzle(TestTileI)
module TII  = TestTilePuzzle(TestTileII)
module TIII  = TestTilePuzzle(TestTileIII)
module TIV = TestTilePuzzle(TestTileIV)
module TV = TestTilePuzzle(TestTileV)

(* modules with test_all_unsolvable function *)
module TIU = TestTileUnsolvable (TestTileIU)
module TIIU = TestTileUnsolvable (TestTileIIU)
module TIIIU = TestTileUnsolvable (TestTileIIIU)
module TIVU = TestTileUnsolvable (TestTileIVU)
module TVU = TestTileUnsolvable (TestTileVU)

let _ =
  TI.test_tile_puzzle 15;
  TI.test_tile_puzzle 30;
  TI.test_tile_puzzle 45;

  TII.test_tile_puzzle 15;
  TII.test_tile_puzzle 30;
  TII.test_tile_puzzle 45;

  TIII.test_tile_puzzle 15;
  TIII.test_tile_puzzle 30;
  
  TIV.test_tile_puzzle 15;
  TIV.test_tile_puzzle 30;;

  TIU.test_all_unsolvable ();
  TIIU.test_all_unsolvable ();
  TIIIU.test_all_unsolvable ();
  TIVU.test_all_unsolvable ();
  TVU.test_all_unsolvable ();;

(*......................................................................
                       SAMPLE MAZE PUZZLE TESTING
*)

(* unsolvable maze modules *)

module TestMazeIU =
  struct
    let maze = square_maze 1 init_unsolvable
    let initial_pos =  (0,0)
    let goal_pos = (4,4)
    let dims = (5,5)
  end

module TestMazeIIU =
struct
    let maze = square_maze 2 init_unsolvable
    let initial_pos =  (0,0)
    let goal_pos = (9,9)
    let dims = (10, 10)
  end

module TestMazeIIIU =
  struct
    let maze = square_maze 3 init_unsolvable
    let initial_pos =  (0,0)
    let goal_pos = (14,14)
    let dims = (15, 15)
  end

module TestMazeIVU =
  struct
    let maze = square_maze 4 init_unsolvable
    let initial_pos =  (0,0)
    let goal_pos = (19,19)
    let dims = (20, 20)
  end

(* solvable maze modules *)

module TestMazeI : MAZEINFO =
  struct
    let maze = square_maze 1 init_maze
    let initial_pos =  (0,0)
    let goal_pos = (4,4)
    let dims = (5, 5)
  end

module TestMazeI' : MAZEINFO =
  struct
    let maze = square_maze 1 init_maze
    let initial_pos =  (4,4)
    let goal_pos = (0,0)
    let dims = (5, 5)
  end

module TestMazeII : MAZEINFO =
  struct
    let maze = square_maze 2 init_maze
    let initial_pos =  (0,0)
    let goal_pos = (9,9)
    let dims = (10, 10)
  end

module TestMazeII' : MAZEINFO =
  struct
    let maze = square_maze 2 init_maze
    let initial_pos =  (9,9)
    let goal_pos = (0,0)
    let dims = (10, 10)
  end

module TestMazeIII : MAZEINFO =
  struct
    let maze = square_maze 3 init_maze
    let initial_pos =  (0,0)
    let goal_pos = (14,14)
    let dims = (15, 15)
  end

module TestMazeIII' : MAZEINFO =
  struct
    let maze = square_maze 3 init_maze
    let initial_pos =  (14,14)
    let goal_pos = (0,0)
    let dims = (15, 15)
  end

module TestMazeIV : MAZEINFO =
  struct
    let maze = square_maze 4 init_maze
    let initial_pos =  (0,0)
    let goal_pos = (19,19)
    let dims = (20, 20)
  end

module TestMazeIV' : MAZEINFO =
  struct
    let maze = square_maze 4 init_maze
    let initial_pos =  (19,19)
    let goal_pos = (0,0)
    let dims = (20, 20)
  end

(* modules with run_tests function *)
module MI = TestMazePuzzle(TestMazeI)
module MI' = TestMazePuzzle(TestMazeI')
module MII  = TestMazePuzzle(TestMazeII)
module MII'  = TestMazePuzzle(TestMazeII')
module MIII = TestMazePuzzle(TestMazeIII)
module MIII' = TestMazePuzzle(TestMazeIII')
module MIV = TestMazePuzzle(TestMazeIV)
module MIV' = TestMazePuzzle(TestMazeIV')

(* modules with test_all_unsolvable function *)
module MIU = TestMazeUnsolvable(TestMazeIU)
module MIIU = TestMazeUnsolvable(TestMazeIIU)
module MIIIU = TestMazeUnsolvable(TestMazeIIIU)
module MIVU = TestMazeUnsolvable(TestMazeIVU)


let _ =
  MI.run_tests ();
  MI'.run_tests ();
  MII.run_tests ();
  MII'.run_tests ();
  MIII.run_tests ();
  MIII'.run_tests ();
  MIV.run_tests ();
  MIV'.run_tests ();
  MIU.test_all_unsolvable ();
  MIIU.test_all_unsolvable ();
  MIIIU.test_all_unsolvable ();
  MIVU.test_all_unsolvable ();;


