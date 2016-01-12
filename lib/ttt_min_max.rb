class TttMinMax
      attr_reader :best_choice

      # ai = MinMax.new(@ttt_game, @ttt_game.current_player[:symbol])
      # ai.move(@ttt_game.board)

      def initialize(piece, win_checker)
        @piece = piece
        @win_checker = win_checker
        # @piece = game.current_player[:symbol]
        @opponent = switch(piece)
      end

      def move(board)
        minmax(board, @piece)
        return best_choice
      end

      def minmax(board, current_player)
        return score(current_player, board) if game_over?(current_player, board)

        scores = {}

        available_spaces(board).each do |space|
          # Copy board so we don't mess up original
          potential_board = board.dup
          potential_board[space] = current_player

          scores[space] = minmax(potential_board, switch(current_player))
        end

        @best_choice, best_score = best_move(current_player, scores)
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
        # board.each_with_index.select { |square, i| square.nil? }.map { |square, i| i }
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