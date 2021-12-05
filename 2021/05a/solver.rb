class Solver
  def after_run
    IO.write('map.txt', hydrothermal_vent_map_as_string) unless debug;
  end

  def line_segments
    @line_segments ||= input_lines.map do |line|
      convert_input_line_to_points(line)
    end.compact
  end

  def convert_input_line_to_points(segment_definition)
    x1, y1, x2, y2 = *segment_definition.split(/\D/).reject{|s|s==''}.map(&:to_i)

    # Intructions said to ignore diagonals and I missed it. Oops!
    # This method works for diagonals if you comment out this line...
    return nil unless x1 == x2 || y1 == y2

    x_points = x1.send(x1 <= x2 ? :upto : :downto, x2).to_a
    y_points = y1.send(y1 <= y2 ? :upto : :downto, y2).to_a
    x_points *= y_points.length if x_points.length == 1
    y_points *= x_points.length if y_points.length == 1

    coordinate_pairs = \
      x_points.each_with_index.map{ |x, i| [x, y_points[i]] }
    log "#{segment_definition} converted to: #{coordinate_pairs.inspect}"

    coordinate_pairs
  end

  def hydrothermal_vent_map
    if @hydrothermal_vent_map.nil?
      map_size = line_segments.flatten.max + 1

      @hydrothermal_vent_map = []
      map_size.times{ @hydrothermal_vent_map << []; map_size.times{ @hydrothermal_vent_map.last << '.' } }

      line_segments.each_with_index do |coordinate_pairs, i|
        coordinate_pairs.each do |coordinates|
          x, y = *coordinates
          map_value = @hydrothermal_vent_map[y][x]
          @hydrothermal_vent_map[y][x] = map_value == '.' ? 1 : (map_value + 1)
        end

        log "After plotting #{coordinate_pairs.inspect}:\n#{@hydrothermal_vent_map.map(&:join).join("\n")}"
      end
    end

    @hydrothermal_vent_map
  end

  def hydrothermal_vent_map_as_string
    hydrothermal_vent_map.map(&:join).join("\n")
  end

  def calculate_answer
    hydrothermal_vent_map.flatten.reject{ |v| %[. 1].include?(v.to_s) }.count
  end
end
