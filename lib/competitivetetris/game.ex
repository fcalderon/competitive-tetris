defmodule Competitivetetris.Game do
  @I_tetromino
  [
    [
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0],
      [0,1,0,0],
    ],
    [
      [0,0,0,0],
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0],

    ],
    [
      [0,0,0,0],
      [1,1,1,1],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0],
      [0,0,1,0],
    ]
  ]
  @O_tetromino
  [
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,2,2,0],
      [0,2,2,0],
      [0,0,0,0],
      [0,0,0,0],
    ]
  ]
  @J_tetromino
  [
    [
      [0,3,0,0],
      [0,3,0,0],
      [3,3,0,0],
      [0,0,0,0],
    ],
    [
      [3,0,0,0],
      [3,3,3,0],
      [0,0,0,0],
      [0,0,0,0],

    ],
    [
      [0,3,3,0],
      [0,3,0,0],
      [0,3,0,0],
      [0,0,0,0],
    ],
    [
      [0,0,0,0],
      [3,3,3,0],
      [0,0,3,0],
      [0,0,0,0],
    ]
  ]
  @Z_tetromino
  [
    [
      [0,4,4,0],
      [4,4,0,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,4,0,0],
      [0,4,4,0],
      [0,0,4,0],
      [0,0,0,0],

    ],
    [
      [0,0,0,0],
      [0,4,4,0],
      [4,4,0,0],
      [0,0,0,0],
    ],
    [
      [4,0,0,0],
      [4,4,0,0],
      [0,4,0,0],
      [0,0,0,0],
    ]
  ]
  @T_tetromino
  [
    [
      [0,5,0,0],
      [5,5,5,0],
      [0,0,0,0],
      [0,0,0,0],
    ],
    [
      [0,5,0,0],
      [0,5,5,0],
      [0,5,0,0],
      [0,0,0,0],

    ],
    [
      [0,0,0,0],
      [5,5,5,0],
      [0,5,0,0],
      [0,0,0,0],
    ],
    [
      [0,5,0,0],
      [5,5,0,0],
      [0,5,0,0],
      [0,0,0,0],
    ]
  ]
  @L_tetromino
  [
    [
      [0,6,0,0],
      [0,6,0,0],
      [0,6,6,0],
      [0,0,0,0],
    ],
    [
      [6,0,0,0],
      [6,6,6,0],
      [0,0,0,0],
      [0,0,0,0],

    ],
    [
      [0,6,6,0],
      [0,6,0,0],
      [0,6,0,0],
      [0,0,0,0],
    ],
    [
      [0,0,0,0],
      [6,6,6,0],
      [6,0,0,0],
      [0,0,0,0],
    ]
  ]
  def new(playerNumber) do
    %{
      players: [
        %{ playerNumber: playerNumber, clicks: 0 }
      ],
    }
  end

  def client_view(game, playerNumber) do
    %{
      lastPlay: playerNumber,
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

  def get_player(game, playerNumber) do
    Enum.find(game.players, fn(p) -> p.playerNumber == playerNumber end)
  end

  def play(game, playerNumber, move) do

  end

  def get_blank_board() do
    [
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
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
      [0,0,0,0,0,0,0,0,0,0],
    ]
  end

  def get_tetrimonio(letter, rotation) do
    case { letter } do
      {:I} -> I_tetromino[rotation]
      {:O} -> O_tetromino[rotation]
      {:J} -> J_tetromino[rotation]
      {:Z} -> Z_tetromino[rotation]
      {:T} -> T_tetromino[rotation]
      {:L} -> L_tetromino[rotation]
    end
  end

  def get_random_tetrimonio() do
    get_tetrimonio(Enum.random([:I, :O, :J, :Z, :T, :L]), 0)
  end

end