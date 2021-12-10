class CodeLine
  attr_accessor :code_line, :first_invalid_character_index, :expected_char

  BRACKET_PAIRS = [['(', ')'], ['{', '}'], ['[', ']'], ['<', '>']]

  INVALIDITY_POINT_MAP = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
  }

  def initialize(code_line)
    self.code_line = code_line
  end

  def characters; @characters ||= self.code_line.split ''; end

  def opening_brackets; BRACKET_PAIRS.map(&:first); end
  def closing_brackets; BRACKET_PAIRS.map(&:last); end

  def first_invalid_character_index
    if @first_invalid_character_index.nil?
      open_bracket_stack = []
      characters.each_with_index do |char, i|
        if opening_brackets.include? char
          open_bracket_stack << char
        else
          last_opening_bracket = open_bracket_stack.pop
          self.expected_char = closing_brackets[opening_brackets.index(last_opening_bracket)]
          if char != self.expected_char
            @first_invalid_character_index = i
            break
          end
        end
      end
    end
    @first_invalid_character_index
  end

  def invalid?; ! first_invalid_character_index.nil?; end

  def first_invalid_character; characters[first_invalid_character_index]; end

  def invalidity_points; invalid? ? INVALIDITY_POINT_MAP[first_invalid_character] : 0; end
end

class Solver
  def calculate_answer
    input_lines.map do |line|
      code_line = CodeLine.new(line)
      log line
      if code_line.invalid?
        bad_index = code_line.first_invalid_character_index
        bad_char = code_line.first_invalid_character
        expected_char = code_line.expected_char
        log "#{' ' * bad_index}^"
        log "Expected '#{expected_char}' at index #{bad_index}, but found '#{bad_char}' instead"
      end
      code_line.invalidity_points
    end.sum
  end
end
