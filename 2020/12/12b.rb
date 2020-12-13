instructions = IO.read('input.txt')

x_pos = 0
y_pos = 0
directions = %w[E S W N]
current_direction_index = 0

instructions.split("\n").each do |line|
  if match_parts = line.match(/([NSEWLRF])([0-9]+)/)
    code, units = *match_parts[1,2]
    units = units.to_i

    output = line

    if directions.include? code
      direction = code
      output += "  :: GO #{direction} #{units}"

    elsif %w[L R].include? code
      quarter_turns = units / 90
      current_direction_index += (code == 'L' ? -1 : 1) * quarter_turns
      current_direction_index %= directions.length
      direction = directions[current_direction_index]
      output += "  :: POINT #{direction}"

      units = 0
    elsif code == 'F'
      direction = directions[current_direction_index]
      output += "  :: GO FORWARD (#{direction}) #{units}"

    else
      raise 'BAD CODE'
    end

    case direction
      when 'N'
        y_pos += units
      when 'S'
        y_pos -= units
      when 'E'
        x_pos += units
      when 'W'
        x_pos -= units
      else
        raise 'BAD DIRECTION'
    end

    output += "  :: now at (#{x_pos}, #{y_pos}) pointing #{directions[current_direction_index]}"

    puts output
  else
    raise '??'
  end
end; nil

puts "ENDING AT #{x_pos}, #{y_pos}"
