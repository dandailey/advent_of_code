class Advent
  def self.input; IO.read('input.txt'); end

  def self.sample_input
    <<-HEREDOC
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
HEREDOC
  end

  def self.print_answer
    code = input
    instruction_count = code.lines.count

    program = Interpreter.new(code)
    program.run

    unless program.completed?
      (0..(instruction_count - 1)).each do |fixer_line_index|
        program = Interpreter.new(code)
        program.toggle_instruction_at(fixer_line_index)
        program.run
        break if program.completed?
      end
    end

    raise "PROGRAM COULDN'T BE FIXED!" unless program.completed?

    puts "ADVENT ANSWER: #{program.accumulator}"
  end
end

class Interpreter
  attr_accessor :instruction_list
  attr_accessor :accumulator
  attr_accessor :current_line_index
  attr_accessor :executed_line_indexes

  def initialize(code);
    @instruction_list = code.split("\n").map do |instruction|
      parts = instruction.match(/^(.+) ([+-]\d+)$/)
      [parts[1], parts[2].to_i]
    end
    @accumulator = 0
    @current_line_index = 0
    @executed_line_indexes = []
  end

  def run
    loop do
      instruction = instruction_list[current_line_index]

      break if executed_line_indexes.include? current_line_index

      @executed_line_indexes << current_line_index

      operation, operand = instruction
      if operation == 'acc'
        @accumulator += operand
        @current_line_index += 1
      elsif operation == 'jmp'
        @current_line_index += operand
      else
        @current_line_index += 1
      end

      break if completed?
    end
  end

  def toggle_instruction_at(line_index)
    operation, operand = instruction_list[line_index]
    if operation == 'nop' && operand.to_i != 0
      @instruction_list[line_index] = ['jmp', operand]
    elsif operation == 'jmp'
      @instruction_list[line_index] = ['nop', operand]
    end
  end

  def completed?; current_line_index == instruction_list.count; end
end

Advent.print_answer