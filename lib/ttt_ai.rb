class TttAi

  def initialize(game)
    @board = game.board
    @current_symbol = game.current_player[:symbol]
  end

  def available_spaces
    @board.each_with_index.select { |square, i| square.nil? }.map { |square, i| i }
    # ((0..8).to_a - Move.where(game_id: id).pluck(:square))
  end

  def available_spaces_minmax(potential_board)
    i = -1
    spaces = potential_board.map do |space| 
      i += 1
      space == nil ? i : nil 
    end
    spaces.compact
  end

  def best_move(current_symbol, scores)
    if current_symbol == ai_symbol
      scores.max_by { |_k, v| v }
    else
      scores.min_by { |_k, v| v }
    end
  end

  def minmax(current_symbol, board)
    return score board if game_over? board
    scores = {}
  
    available_spaces_minmax(board).each do |space|
      potential_board ||= board.dup
      potential_board[space] = current_symbol
      scores[space] = minmax(switch(current_symbol),potential_board)

    end
    @best_choice, best_score = best_move(current_symbol, scores)
    best_score
  end

  def maxmin(current_symbol, board)
    return reverse_score board if game_over? board
    scores = {}
  
    available_spaces_minmax(board).each do |space|
      potential_board ||= board.dup
      potential_board[space] = current_symbol
      scores[space] = maxmin(switch(current_symbol),potential_board)

    end
    @best_choice, best_score = best_move(current_symbol, scores)
    best_score
  end
end