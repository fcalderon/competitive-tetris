defmodule Competitivetestris.GameTest do
  use ExUnit.Case
  doctest Competitivetetris.Game
  alias Competitivetetris.Game

  test "Collission detected" do
    game = Game.new("1")
    assert Game.get_player(game, "1").playerNumber == "1"
  end

end