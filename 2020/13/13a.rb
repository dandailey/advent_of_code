class AdventSolver
  attr_accessor :debug

  def real_input; IO.read('input.txt'); end

  def sample_input
    <<-HEREDOC
939
7,13,x,x,59,x,31,19
HEREDOC
  end

  def input; debug ? sample_input : real_input; end

  def print_answer
    puts "ADVENT ANSWER: #{answer}"
  end

  def answer
    nearest_departure_times_map(earliest_timestamp).keys.first *
      (nearest_departure_times_map(earliest_timestamp).values.first - earliest_timestamp)
  end

  def next_departing_bus_after_timestamp(timestamp)
  end

  def nearest_departure_times_map(timestamp)
    @nearest_departure_times_map ||= \
      Hash[*(
        bus_id_list.map do |bus_id|
          [bus_id, next_departure_for_bus_after_timestamp(bus_id, timestamp)]
        end
        .sort do |a, b|
          a.last <=> b.last
        end.flatten
      )]
  end

  def next_departure_for_bus_after_timestamp(bus_id, timestamp)
    if timestamp % bus_id == 0
      timestamp
    else
      (timestamp - (timestamp % bus_id)) + bus_id
    end
  end

  def earliest_timestamp; @earliest_timestamp ||= input.split("\n").first.to_i; end
  def bus_id_list; @bus_id_list ||= input.split("\n").last.split(',').map(&:to_i).uniq.select{|x|x.to_i > 0}.sort; end
end

solver = AdventSolver.new
# solver.debug = true
solver.print_answer