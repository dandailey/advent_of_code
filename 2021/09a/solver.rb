class HeightMap
  attr_accessor :raw_input, :map

  def initialize(raw_input)
    self.raw_input = raw_input
    self.map = raw_input.split("\n").map{ |v| v.split('').map(&:to_i) }
  end

  def low_points
    @low_points ||= []
    if @low_points == []
      map.each_with_index do |row, y|
        row.each_with_index do |height, x|
          if (
            (! map[y-1] || map[y-1][x] > height) &&
            (! map[y+1] || map[y+1][x] > height) &&
            (! row[x-1] || row[x-1] > height) &&
            (! row[x+1] || row[x+1] > height)
          )
            @low_points << { height: height, x: x, y: y }
          end
        end
      end
    end
    @low_points
  end
end

class Solver
  def calculate_answer
    map = HeightMap.new(input)
    map.low_points.map{ |point| point[:height] + 1 }.sum
  end
end
