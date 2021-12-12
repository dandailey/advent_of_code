class Timeline
  attr_accessor :timeline

  def initialize(starting_octogrid)
    self.timeline = [starting_octogrid]
  end

  def octogrid_at_step(step)
    if step >= self.timeline.length
      previous_octogrid = octogrid_at_step(step - 1)
      self.timeline[step] = previous_octogrid.next_octogrid
    end
    self.timeline[step]
  end

  def run_to(step_count); octogrid_at_step(step_count); end

  def flash_count_at_step(step)
    run_to step
    timeline.map{ |og| og.flash_count }.sum
  end
end

class Octogrid
  attr_accessor \
    :grid

  def initialize(input)
    self.grid = input.split("\n").each_with_index.map do |row, y|
      row.split('').each_with_index.map do |octopus_energy_level, x|
        Octopus.new(
          [x, y],
          octopus_energy_level.to_i,
          flash_callback: lambda { |octopus|
            handle_flashed_octopus octopus
          }
        )
      end
    end
  end

  def octopus_at(coordinates); grid[coordinates.last][coordinates.first]; end

  def coordinates_surrounding(coordinates)
    x, y = *coordinates
    coordinate_list = []
    coordinate_list << [x-1, y-1] unless x == 0 || y == 0
    coordinate_list << [x, y-1] unless y == 0
    coordinate_list << [x+1, y-1] unless x+1 >= grid[y].length || y == 0
    coordinate_list << [x-1, y] unless x == 0
    coordinate_list << [x+1, y] unless x+1 >= grid[y].length
    coordinate_list << [x-1, y+1] unless x == 0 || y+1 >= grid.length
    coordinate_list << [x, y+1] unless y+1 >= grid.length
    coordinate_list << [x+1, y+1] unless x+1 >= grid[y].length || y+1 >= grid.length
    coordinate_list
  end

  def handle_flashed_octopus(octopus)
    coordinates_surrounding(octopus.coordinates).each do |coordinates|
      octopus_at(coordinates).react_to_neighboring_flash
    end
  end

  def each_octopus; grid.each { |row| row.each { |octopus| yield octopus } }; end

  def charged_octopuses
    @charged_octopuses ||= grid.flatten.select{ |octopus| octopus.energy_level == 9 }
  end

  def next_octogrid
    new_octogrid = Octogrid.new(self.to_s)
    new_octogrid.each_octopus{ |octopus| octopus.power_up }
    new_octogrid.each_octopus{ |octopus| octopus.try_to_flash }
    new_octogrid
  end

  def flash_count
    @flash_count ||= grid.flatten.map{|o| o.just_flashed? ? 1 : 0 }.sum
  end

  def to_s
    @str ||= grid.map{ |row| row.map{ |octopus| octopus.energy_level }.join }.join("\n")
  end
end

class Octopus
  attr_accessor :coordinates, :energy_level, :flash_callback, :just_flashed

  def initialize(coordinates, energy_level, options = {})
    self.coordinates = coordinates
    self.energy_level = energy_level
    self.flash_callback = options[:flash_callback]
  end

  def power_up; self.energy_level += 1; end

  def try_to_flash; flash if energy_level > 9; end

  def react_to_neighboring_flash
    unless just_flashed?
      power_up
      try_to_flash
    end
  end

  def flash
    self.energy_level = 0
    unless just_flashed?
      self.just_flashed = true
      flash_callback.call(self) if flash_callback
    end
  end

  def just_flashed?; !! self.just_flashed; end
end

class Solver
  def calculate_answer
    starting_octogrid = Octogrid.new(input)
    timeline = Timeline.new(starting_octogrid)
    timeline.flash_count_at_step(100)
  end
end
