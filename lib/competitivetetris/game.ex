defmodule Competitivetetris.Game do
  def new(playerNumber) do
    %{
      players: [
        %{ playerNumber: playerNumber, clicks: 0 }
        ],
    }
  end

  def client_view(game, playerNumber) do
    %{
      players: game.players,
    }
  end

  def play(game, playerNumber) do
    Map.put(game, :players, Enum.map(game.players, fn(player) -> updatePlayer(player, playerNumber, 0) end))
  end

  defp updatePlayer(player, playerNumber, play) do
    updated = player
    if (player.playerNumber == playerNumber) do
      updated = Map.put(updated, :clicks, player.clicks + 1)
    end
    updated
  end

  def join(game, playerNumber) do
    if Enum.any?(game.players, fn(player) -> player.playerNumber == playerNumber end) do
      game
    else
      Map.put(game, :players, Enum.concat(game.players, [%{:playerNumber => playerNumber, :clicks => 0}]))
    end
  end
end