Array.define_method :median do
  sorted = self.sort
  length = sorted.length
  length % 2 == 0 \
    ? (sorted[length / 2] + sorted[(length / 2) - 1]) / 2.0
    : sorted[length / 2]
end

class Solver
  def h_position_list; @h_position_list ||= input.split(',').map(&:to_i); end

  def steps_to_median
    median = h_position_list.median.round
    input.map{ |v| (v - median).abs }.sum
  end

  def calculate_answer
    median = h_position_list.median.round
    h_position_list.map{ |v| (v - median).abs }.sum
  end
end
