class AdventSolver
  attr_accessor :debug, :show_output, :output_log, :answer

  def real_input; IO.read('input.txt'); end

  def sample_input
    <<-HEREDOC
forward 5
down 5
forward 8
up 3
down 8
forward 2
HEREDOC
  end

  def input; debug ? sample_input : real_input; end

  def log(val); self.output_log ||= []; self.output_log << val; end

  def print_answer
    self.output_log.each { |line| puts line } if show_output
    puts "ADVENT ANSWER: #{answer}"
  end

  # CORRECT ANSWER IS: 1882980
  def calculate_answer
    h_pos = 0
    depth = 0
    instruction_list.each do |instruction|
      cmd, val = *(instruction.split(' '))
      log instruction
      if cmd == 'forward'
        h_pos += val.to_i
        log "H Pos is now #{h_pos}"
      else
        depth += val.to_i * (cmd == 'down' ? 1 : -1)
        log "Depth is now #{depth}"
      end
    end
    self.answer = h_pos * depth
  end

  def instruction_list; @instruction_list ||= input.split("\n"); end
end

solver = AdventSolver.new
# solver.debug = true
# solver.show_output = true
solver.calculate_answer
solver.print_answer


# Now, you need to figure out how to pilot this thing.

# It seems like the submarine can take a series of commands like forward 1,
# down 2, or up 3:

# forward X increases the horizontal position by X units. down X increases the
# depth by X units. up X decreases the depth by X units. Note that since
# you're on a submarine, down and up affect your depth, and so they have the
# opposite result of what you might expect.

# The submarine seems to already have a planned course (your puzzle input).
# You should probably figure out where it's going. For example:

# forward 5 down 5 forward 8 up 3 down 8 forward 2 Your horizontal position
# and depth both start at 0. The steps above would then modify them as
# follows:

# forward 5 adds 5 to your horizontal position, a total of 5. down 5 adds 5 to
# your depth, resulting in a value of 5. forward 8 adds 8 to your horizontal
# position, a total of 13. up 3 decreases your depth by 3, resulting in a
# value of 2. down 8 adds 8 to your depth, resulting in a value of 10.
# forward 2 adds 2 to your horizontal position, a total of 15. After
# following these instructions, you would have a horizontal position of 15
# and a depth of 10. (Multiplying these together produces 150.)

# Calculate the horizontal position and depth you would have after following
# the planned course. What do you get if you multiply your final horizontal
# position by your final depth?
