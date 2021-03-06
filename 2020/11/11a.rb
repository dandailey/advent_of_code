class AdventSolver
  attr_accessor :debug

  def real_input; IO.read('input.txt'); end

  def sample_input
    <<-HEREDOC
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
HEREDOC
  end

  def input; debug ? sample_input : real_input; end

  def print_answer
    puts "ADVENT ANSWER: #{answer}"
  end

  def answer
    iterate_map_until_stable
    total_occupied_count
  end

  def iterate_map_until_stable
    (1..).each do |iteration|
      old_map = map.dup
      iterate_map
      return iteration if old_map == map
    end
  end

  def iterate_map
    new_map = []
    map.each_with_index do |row, r|
      new_row = []
      row.each_with_index do |symbol, c|
        if symbol == 'L' && occupied_neighbor_count(r, c, 1) == 0
          new_row << '#'
        elsif symbol == '#' && occupied_neighbor_count(r, c, 4) >= 4
          new_row << 'L'
        else
          new_row << symbol
        end
      end
      new_map << new_row
    end
    @map = new_map
  end

  def occupied_neighbor_count(r, c, stop_at = nil)
    counter = 0
    ((r-1)..(r+1)).each do |r_check|
      ((c-1)..(c+1)).each do |c_check|
        next if r_check < 0 || c_check < 0 || r_check >= map_row_count || c_check >= map_col_count || (r_check == r && c_check == c)
        counter += 1 if map[r_check][c_check] == '#'
        return counter if ! stop_at.nil? && counter >= stop_at
      end
    end
    counter
  end

  def total_occupied_count
    map.flatten.join('').count('#')
  end

  def map; @map ||= input.split("\n").map{|row|row.split('')}; end
  def map_row_count; @map_row_count ||= map.count; end
  def map_col_count; @map_col_count ||= map.first.count; end
end

solver = AdventSolver.new
# solver.debug = true
solver.print_answer