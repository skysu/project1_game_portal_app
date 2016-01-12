require 'ttt_win_checker'

class TttMinMax
  attr_reader :best_choice

  def initialize(piece)
    @piece = piece
    @opponent = switch(piece)
    @win_checker = TttWinChecker.new
  end

  def choose_square(board)
    minmax(board, @piece)
    return best_choice
  end

  def minmax(board, current_piece)
    return score(current_piece, board) if game_over?(current_piece, board)

    scores = {}

    available_spaces(board).each do |space|
      # Copy board so we don't mess up original
      potential_board = board.dup
      potential_board[space] = current_piece

      scores[space] = minmax(potential_board, switch(current_piece))
    end

    @best_choice, best_score = best_move(current_piece, scores)
    best_score
  end

  def game_over?(piece, board)
    winner?(piece, board) || tie?(board)
  end

  def best_move(piece, scores)
    if piece == @piece
      scores.max_by { |_k, v| v }
    else
      scores.min_by { |_k, v| v }
    end
  end

  def score(piece, board)
    if winner?(piece, board) == @piece
      return 10
    elsif winner?(piece, board) == @opponent
      return -10
    end
    0
  end

  def switch(piece)
    piece == :x ? :o : :x
  end

  def available_spaces(board)
    available = []
    board.each_index do |i|
      available << i if board[i].nil?
    end
    available
  end

  def winner?(piece, board)
    @win_checker.winner(piece, board)
  end

  def tie?(board)
    available_spaces(board).empty?
  end
end