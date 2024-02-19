class Turn

  def initialize(player_board, computer_board)
    @player_board = player_board
    @computer_board = computer_board
  end

  def display_both_boards
    display_player_board +
    display_computer_board
  end

  def display_player_board
    "==============PLAYER BOARD==============\n" +
    @player_board.render(true)
  end

  def display_computer_board
    "==============COMPUTER BOARD==============\n" +
    @computer_board.render
  end

  def get_computer_shot
    blank_coordinates = []
    @player_board.cells.each do |coordinate, cell|
      if !cell.fired_upon?
        blank_coordinates << coordinate
      end
    end
    coordinate_to_fire_upon = blank_coordinates.sample
    @player_board.cells[coordinate_to_fire_upon].fire_upon
  end


end
