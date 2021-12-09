class HeightMap
  attr_accessor :raw_input, :map

  def initialize(raw_input)
    self.raw_input = raw_input
    self.map = raw_input.split("\n").map{ |v| v.split('').map(&:to_i) }
  end

  def height_at(x, y); map[y][x]; end

  def low_points
    @low_points ||= []
    if @low_points == []
      map.each_with_index do |row, y|
        row.each_with_index do |height, x|
          surrounding_points = points_surrounding(x, y)
          higher_points = \
            surrounding_points.reject do |coords|
              height_at(coords.first, coords.last) <= height
            end
          if higher_points.length == surrounding_points.length
            @low_points << { height: height, x: x, y: y }
          end
        end
      end
    end
    @low_points
  end

  def points_surrounding(x, y)
    point_list = []
    point_list << [x, y-1] unless y == 0
    point_list << [x, y+1] unless y+1 >= map.length
    point_list << [x-1, y] unless x == 0
    point_list << [x+1, y] unless x+1 >= map[y].length
    point_list
  end

  def basin_list
    @basin_list ||= low_points.map{ |point| Basin.new(self, [point[:x], point[:y]]) }
  end
end

class Basin
  attr_accessor :map, :low_point, :point_list

  def initialize(map, low_point)
    self.map = map
    self.low_point = low_point
    self.point_list = []
    add_point self.low_point
  end

  def add_point(new_point)
    point_list << new_point
    map.points_surrounding(*new_point).each do |border_point|
      unless map.height_at(*border_point) == 9 || point_list.index(border_point)
        add_point border_point
      end
    end
  end

  def size; point_list.length; end
end

class Solver
  def calculate_answer
    map = HeightMap.new(input)
    map.basin_list.map(&:size).sort[-3, 3].inject(:*)
  end
end
