class Solver
  def parse_output_values(str)
    str.split(' | ').last.split(' ')
  end

  def calculate_answer
    input_lines.map do |line|
      parse_output_values(line).
        map(&:length).
        select{ |v| [2, 3, 4, 7].include?(v) }.
        flatten.
        length
    end.sum
  end
end
