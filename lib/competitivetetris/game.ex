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
        [0,0,1,0],
        [0,0,1,0],
        [0,0,1,0],
        [0,0,1,0],
      ],
      [
        [0,0,0,0],
        [1,1,1,1],
        [0,0,0,0],
        [0,0,0,0],
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
  def new_player(playerNumber) do
    randomShape = get_random_tetrimonio_letter()
    shapeTetrimonio = get_tetrimonio(randomShape, 0)
    %{
      playerNumber: playerNumber,
      landed: get_blank_board(),
      topLeft: %{ row: 0, col: 4},
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

  def get_visible_board(landed, currentTetrimonio, topLeft) do
    visible = landed
    |> Enum.with_index
    |> Enum.map(
         fn({row, rowIndex})
         -> row
            |> Enum.with_index
            |> Enum.map(
                 fn({col, colIndex})
                 -> cel_val(col, rowIndex, colIndex, topLeft, currentTetrimonio)
                 end)
         end)
    visible
  end

  def cel_val(col, rowIndex, colIndex, topLeft, currentTetrimonio) do
    if (col == 0 && rowIndex >= topLeft.row && rowIndex < topLeft.row + 4
        && colIndex >= topLeft.col && colIndex < topLeft.col + 4) do
      tEl = get_val_at(currentTetrimonio, rowIndex - topLeft.row, colIndex - topLeft.col)
      if (tEl != 0) do
        tEl
      else
        col
      end
    else
      col
    end
  end

  def progress_board(game) do
    Map.put(game, :players, Enum.map(game.players, fn(player) -> progress_player(player) end))
  end

  def progress_player(player) do
    updated = player
    # Increase row

    nextMove = %{ row: player.topLeft.row + 1, col: player.topLeft.col }

    willCollide = will_collide(player, nextMove)

    IO.puts("Will collide?")
    IO.inspect(willCollide)

    if (willCollide) do
      IO.puts("Willllll Collide!!!")
      newTetrimonioLetter = get_random_tetrimonio_letter()
      updated = Map.merge(updated, %{
        landed: get_visible_board(player.landed, player.currentTetrimonio, player.topLeft),
        topLeft: %{row: 0, col: 4},
        currentTetrimonio: get_tetrimonio(newTetrimonioLetter, 0),
        tetrimonioLetter: newTetrimonioLetter,
        rotationIndex: 0
      })
      IO.inspect(updated)
      updated
    else
      Map.put(updated, :topLeft, nextMove)
    end
  end

  def will_collide(player, potentialNext) do
    landed = player.landed
    tetrimonio = player.currentTetrimonio
    tetrimonio
    |> Enum.with_index
    |> Enum.any?(
         fn({row, rowIndex}) ->
           row
           |> Enum.with_index
           |> Enum.any?(
                fn({col, colIndex}) ->
                  col != 0 && (((rowIndex + potentialNext.row >= length(player.landed))
                               || ((Enum.at(Enum.at(landed, rowIndex + potentialNext.row),
                                      colIndex + potentialNext.col)) != 0)) || colIndex + potentialNext.col < 0)
                end)
         end)
  end

  def play(game, playerNumber, move) do
    Map.put(game, :players, Enum.map(game.players, fn(player) -> apply_player_move(player, playerNumber, move) end))
  end

  def apply_player_move(player, playerNumber, move) do
    updated = player

    if (player.playerNumber == playerNumber) do
      potentialPlayer = player
      case { move } do
        {"move_left"} ->
          potentialPlayer = Map.put(updated, :topLeft, %{ row: player.topLeft.row, col: player.topLeft.col - 1})
        {"move_right"} ->
          potentialPlayer = Map.put(updated, :topLeft, %{ row: player.topLeft.row, col: player.topLeft.col + 1})
        {"rotate"} ->
          rotationIndex = player.rotationIndex + 1
          if (rotationIndex > 3) do
            rotationIndex = 0
          end
          potentialPlayer = Map.merge(updated,
            %{
              rotationIndex: rotationIndex,
              currentTetrimonio: get_tetrimonio(player.tetrimonioLetter, rotationIndex)
            })
        {"soft_drop"} ->
          IO.puts("Soft drop")
        {"hard_drop"} ->
          IO.puts("Hard drop")
      end
      if (!will_collide(potentialPlayer, potentialPlayer.topLeft)) do
        potentialPlayer
      else
        player
      end
    else
      player
    end
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


  def get_val_at(biDimensionalArray, row, col) do
    Enum.at(Enum.at(biDimensionalArray, row), col)
  end

end