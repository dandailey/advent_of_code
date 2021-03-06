class Advent
  def self.input; IO.read('input.txt'); end

  def self.sample_input
    <<-HEREDOC
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
HEREDOC
  end

  def self.print_answer
    previous_seat_id = 0
    seat_list = input.split("\n").
      map { |encoded_seat_number| Seat.new(encoded_seat_number) }.
      sort { |a, b| a.seat_id <=> b.seat_id }.
    each do |seat|
      puts seat.encoded_seat_number + ': ' + seat.binary_seat_number + " (row #{seat.seat_row}, column #{seat.seat_column}, id ##{seat.seat_id})" + (seat.seat_id == previous_seat_id + 2 ? '  << -- GAP!!' : '')
      break if seat.seat_id == previous_seat_id + 2
      previous_seat_id = seat.seat_id
    end
    puts "ANSWER: #{previous_seat_id + 1}"
  end
end

class Seat
  attr_accessor :encoded_seat_number

  def initialize(encoded_seat_number)
    @encoded_seat_number = encoded_seat_number
  end

  def binary_seat_number
    @binary_seat_number ||= \
      encoded_seat_number.
        gsub('F', '0').gsub('B', '1').
        gsub('L', '0').gsub('R', '1')
  end

  def seat_row; @seat_row ||= binary_seat_number[0,7].to_i(2); end
  def seat_column; @seat_column ||= binary_seat_number[7,3].to_i(2); end
  def seat_id; @seat_id ||= (seat_row * 8) + seat_column; end
end

Advent.print_answer