defmodule Competitivetestris.GameTest do
  use ExUnit.Case
  doctest Competitivetetris.Game
  alias Competitivetetris.Game

  test "Collission detected" do
    game = Game.new("1")
    assert Game.get_player(game, "1").playerNumber == "1"
  end

  test "Will collideee" do
    game = Game.new("1")
    player = Game.new_player("1")
    player = Map.put(player, :currentTetrimonio, Game.i_tetromino())
    player = Map.put(player, :tetrimonioLetter, "I")

    assert Game.will_collide(player,  %{ row: length(player.landed) - 3, col: 4}) == true
  end


  test "Will collid" do
    game = Game.new("1")
    player = Game.new_player("1")
    player = Map.put(player, :currentTetrimonio, Game.get_tetrimonio(:O, 0))
    player = Map.put(player, :tetrimonioLetter, "O")

    assert Game.will_collide(player,  %{ row: length(player.landed) - 4, col: 4}) == false
    assert Game.will_collide(player,  %{ row: length(player.landed) - 3, col: 4}) == false
    assert Game.will_collide(player,  %{ row: length(player.landed) - 2, col: 4}) == false
    assert Game.will_collide(player,  %{ row: length(player.landed) - 1, col: 4}) == true
    assert Game.will_collide(player,  %{ row: length(player.landed), col: 4}) == true
  end

  test "Boards match" do
    game = Game.new("1")
    player = Game.new_player("1")
    player = Map.put(player, :currentTetrimonio, Game.get_tetrimonio(:O, 0))
    player = Map.put(player, :tetrimonioLetter, "O")
    player = Map.put(player, :topLeft, %{row: length(player.landed) - 4, col: 4})

    IO.inspect(Game.get_visible_board(player.landed, player.currentTetrimonio, player.topLeft))
    assert   [
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,2,2,0,0,0],
               [0,0,0,0,0,2,2,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
               [0,0,0,0,0,0,0,0,0,0],
             ] == Game.get_visible_board(player.landed, player.currentTetrimonio, player.topLeft)
  end

  test "get value at" do
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 0, 0)
    assert 1 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 0, 1)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 0, 0)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 0, 0)

    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 1, 0)
    assert 1 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 1, 1)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 1, 0)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 1, 0)

    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 2, 0)
    assert 1 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 2, 1)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 2, 0)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 2, 0)

    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 3, 0)
    assert 1 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 3, 1)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 3, 0)
    assert 0 == Game.get_val_at(Game.get_tetrimonio(:I, 0), 3, 0)
  end

  test "cel_val" do
    currentTetrimonio = Game.get_tetrimonio(:I, 0)
    blankBoard = Game.get_blank_board()
    lastRow = 10

    assert 0 == Game.cel_val(0, 10, 4, %{ row: 10, col: 4}, currentTetrimonio)

    assert 1 == Game.cel_val(0, 10, 5, %{ row: 10, col: 4}, currentTetrimonio)
  end

end