class Solver
  def calculate_answer
    instruction_list = input_lines
    h_pos = 0
    depth = 0
    aim = 0

    instruction_list.each do |instruction|
      cmd, val = *(instruction.split(' '))
      log instruction
      if cmd == 'forward'
        h_pos += val.to_i
        log "H Pos is now #{h_pos}"
        depth += val.to_i * aim
        log "Depth is now #{depth}"
      else
        aim += val.to_i * (cmd == 'down' ? 1 : -1)
        log "Aim is now #{depth}"
      end
    end
    self.answer = h_pos * depth
  end
end
