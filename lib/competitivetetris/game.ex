defmodule Competitivetetris.Game do
  def i_tetromino() do
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
  end

  def o_tetromino do
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
  end

  def j_tetromino do
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
  end

  def z_tetromino do
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
  end

  def t_tetromino do
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
  end
  def l_tetromino do
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
  end
  defp new_player(playerNumber) do
    randomShape = get_random_tetrimonio_letter()
    shapeTetrimonio = get_tetrimonio(randomShape, 0)
    %{
      playerNumber: playerNumber,
      landed: get_blank_board(),
      visibleBoard: get_blank_board(),
      topLeft: %{ row: -4, col: 4},
      currentTetrimonio:  shapeTetrimonio,
      tetrimonioLetter: randomShape,
      rotationIndex: 0
    }
  end

  def new(playerNumber) do
    randomShape = get_random_tetrimonio_letter()
    shapeTetrimonio = get_tetrimonio(randomShape, 0)
    IO.inspect(shapeTetrimonio)
    %{
      currentShape: randomShape,
      currentTetrimonio: shapeTetrimonio,
      players: [
        new_player(playerNumber)
      ],
    }
  end

  def join(game, playerNumber) do
    if Enum.any?(game.players, fn(player) -> player.playerNumber == playerNumber end) do
      game
    else
      Map.put(game, :players, Enum.concat(game.players, [new_player(playerNumber)]))
    end
  end

  def get_player(game, playerNumber) do
    Enum.find(game.players, fn(p) -> p.playerNumber == playerNumber end)
  end


  def client_view(game, playerNumber) do
    %{
      currentShape: game.currentShape,
      currentTetrimonio: game.currentTetrimonio,
      lastPlay: playerNumber,
      players: Enum.map(game.players, fn(p) -> get_player_client_view(p) end),
    }
  end

  defp get_player_client_view(player) do
    %{
      playerNumber: player.playerNumber,
      landed: player.landed,
      visibleBoard: get_visible_board(player.landed, player.currentTetrimonio, player.topLeft)
    }
  end

  defp get_visible_board(landed, currentTetrimonio, topLeft) do
    visible = landed
    |> Enum.with_index
    |> Enum.map( fn({row, rowIndex}) -> row |> Enum.with_index |> Enum.map(fn({col, colIndex}) -> cel_val(col, rowIndex, colIndex, topLeft, currentTetrimonio) end) end)

    IO.puts("Visible board for player:")
    IO.inspect(topLeft)
    IO.inspect(visible)

    visible
  end

  defp cel_val(col, rowIndex, colIndex, topLeft, currentTetrimonio) do
#    IO.puts("Drawing tetrimonio")
#    IO.inspect(currentTetrimonio)
#    IO.inspect(%{ rowIndex: rowIndex, colIndex: colIndex})
#    IO.inspect(topLeft)
    if (rowIndex >= topLeft.row && rowIndex <= topLeft.row + 4
        && colIndex >= topLeft.col && colIndex <= topLeft.col + 4) do
      Enum.at(Enum.at(currentTetrimonio, (topLeft.row + 3) - rowIndex), (topLeft.col + 3) - colIndex)
    else
      col
    end
  end

  def progress_board(game) do
    Map.put(game, :players, Enum.map(game.players, fn(player) -> progress_player(player) end))
  end

  def progress_player(player) do
    updated = player
    # TODO check for conlisions
    # Increase row
    updated = Map.put(updated, :topLeft, %{ row: player.topLeft.row + 1, col: player.topLeft.col })

    updated
  end

  def play(game, playerNumber, move) do
    Map.put(game, :players, Enum.map(game.players, fn(player) -> apply_player_move(player, playerNumber, move) end))
  end

  def apply_player_move(player, playerNumber, move) do
    updated = player

    if (player.playerNumber == playerNumber) do
      case { move } do
        {"move_left"} ->
          updated = Map.put(updated, :topLeft, %{ row: player.topLeft.row, col: player.topLeft.col - 1})
        {"move_right"} ->
          updated = Map.put(updated, :topLeft, %{ row: player.topLeft.row, col: player.topLeft.col + 1})
        {"rotate"} ->
          rotationIndex = player.rotationIndex + 1
          if (rotationIndex > 3) do
            rotationIndex = 0
          end
          updated = Map.put(updated, :rotationIndex, rotationIndex, :currentTetrimonio,
            get_tetrimonio(player.tetrimonioLetter, rotationIndex))
        {"soft_drop"} ->
          IO.puts("Soft drop")
        {"hard_drop"} ->
          IO.puts("Hard drop")
      end
    end

    updated
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
      {:I} -> Enum.at(i_tetromino(),rotation)
      {:O} -> Enum.at(o_tetromino(), rotation)
      {:J} -> Enum.at(j_tetromino(), rotation)
      {:Z} -> Enum.at(z_tetromino(), rotation)
      {:T} -> Enum.at(t_tetromino(), rotation)
      {:L} -> Enum.at(l_tetromino(), rotation)
    end
  end

  def get_random_tetrimonio_letter() do
    Enum.random([:I, :O, :J, :Z, :T, :L])
  end

end