instructions = IO.read('input.txt')

ship_x = 0
ship_y = 0
waypoint_dx = 10
waypoint_dy = 1

instructions.split("\n").each do |line|
  if match_parts = line.match(/([NSEWLRF])([0-9]+)/)
    code, units = *match_parts[1,2]
    units = units.to_i

    output = line

    if %w[E S W N].include? code
      case code
        when 'N'
          waypoint_dy += units
        when 'S'
          waypoint_dy -= units
        when 'E'
          waypoint_dx += units
        when 'W'
          waypoint_dx -= units
        else
          raise 'BAD DIRECTION'
      end
      output += "  :: WAYPOINT #{code} #{units}"

    elsif %w[L R].include? code
      quarter_turns = units / 90
      quarter_turns.times do
        if code == 'L'
          waypoint_dy *= -1
          waypoint_dy, waypoint_dx = waypoint_dx, waypoint_dy
        else
          waypoint_dx *= -1
          waypoint_dy, waypoint_dx = waypoint_dx, waypoint_dy
        end
      end
      output += "  :: WAYPOINT ROTATE #{code}"

      units = 0
    elsif code == 'F'
      units.times do
        ship_x += waypoint_dx
        ship_y += waypoint_dy
      end
      output += "  :: FOLLOW WAYPOINT #{units} TIMES"

    else
      raise 'BAD CODE'
    end

    output += "  :: ship now at (#{ship_x}, #{ship_y}) waypoint is at (#{waypoint_dx}, #{waypoint_dy})"

    puts output
  else
    raise '??'
  end
end; nil

puts "ENDING AT #{ship_x}, #{ship_y}"
