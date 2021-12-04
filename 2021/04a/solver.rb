class Solver
  SIDE_LENGTH = 5

  def marked_board_list; @marked_board_list ||= [[nil] * (SIDE_LENGTH**2)] * board_list.length; end

  def input_parts; @input_parts ||= input.split("\n\n"); end

  def called_numbers; @called_numbers ||= input_parts.first.split(','); end

  def board_list
    @board_list ||= \
      input_parts[1, input_parts.length - 1].map do |unparsed_board|
        unparsed_board.split("\n").map { |line| line.split(' ').compact }.flatten
      end
  end

  def we_have_a_winner?
    board_list.each_with_index do |board, board_index|
      return true if board_is_winner?(board_index)
    end
    false
  end

  def board_is_winner?(board_index)
    board = board_list[board_index]
    log "Checking board #{board_index}: #{board_list[board_index]}"

    winner_found = false

    SIDE_LENGTH.times do |i|
      log "row #{i}: #{board[i * SIDE_LENGTH, SIDE_LENGTH]}"
      if board[i * SIDE_LENGTH, SIDE_LENGTH] == [nil] * SIDE_LENGTH
        log "row #{i} WINS!"
        winner_found = true
        break
      end
    end

    unless winner_found
      SIDE_LENGTH.times do |i|
        column = []
        SIDE_LENGTH.times do |j|
          column << board[i + (j * SIDE_LENGTH)]
        end

        log "column #{i}: #{column}"
        if column == [nil] * SIDE_LENGTH
          log "column #{i} WINS!"
          winner_found = true
          break
        end
      end
    end

    log "Board #{board_index} #{winner_found ? 'is' : 'is not'} a winner"

    winner_found
  end

  def calculate_answer
    called_numbers.each do |called_number|
      log "CALLED: #{called_number}"
      board_list.each_with_index do |board, board_index|
        if i = board.index(called_number)
          board_list[board_index][i] = nil
        end

        if we_have_a_winner?
          return called_number.to_i * board_list[board_index].compact.map(&:to_i).sum
        end
      end
    end
  end
end
