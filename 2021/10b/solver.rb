class CodeLine
  attr_accessor \
    :code_line,
    :first_invalid_character_index,
    :open_bracket_stack

  BRACKET_PAIRS = [['(', ')'], ['{', '}'], ['[', ']'], ['<', '>']]

  INVALIDITY_POINT_MAP = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137,
  }

  INCOMPLETION_POINT_MAP = INVALIDITY_POINT_MAP.keys.each_with_index.map{ |char, i| [char, i + 1] }.to_h

  def initialize(code_line)
    self.code_line = code_line
    parse_line
  end

  def characters; @characters ||= self.code_line.split ''; end

  def opening_brackets; BRACKET_PAIRS.map(&:first); end
  def closing_brackets; BRACKET_PAIRS.map(&:last); end

  def parse_line
    @open_bracket_stack = []
    self.first_invalid_character_index = nil

    characters.each_with_index do |char, i|
      if opening_brackets.include? char
        @open_bracket_stack << char
      else
        if char != next_expected_closing_bracket
          self.first_invalid_character_index = i
          break
        else
          @open_bracket_stack.pop
        end
      end
    end
  end

  def expected_closer_for(opening_bracket_char)
    closing_brackets[opening_brackets.index(opening_bracket_char)]
  end

  def next_expected_closing_bracket;
    expected_closer_for open_bracket_stack.last
  end

  def completion_sequence; open_bracket_stack.reverse.map{ |char| expected_closer_for char }; end

  def invalid?; ! first_invalid_character_index.nil?; end
  def incomplete?; first_invalid_character_index.nil?; end

  def first_invalid_character; characters[first_invalid_character_index]; end

  def invalidity_points; invalid? ? INVALIDITY_POINT_MAP[first_invalid_character] : 0; end
  def incompletion_points
    score = 0
    if incomplete?
      completion_sequence.each do |char|
        score = (score * 5) + INCOMPLETION_POINT_MAP[char]
      end
    end
    score
  end
end

class Solver
  def calculate_answer
    solving_for = :incompletion

    score_list = \
      input_lines.map do |line|
        code_line = CodeLine.new(line)
        log ''
        log line
        if code_line.incomplete?
          log "Line incomplete. Missing: '#{code_line.completion_sequence.join}'"
          log "#{code_line.incompletion_points} incompletion points"
          solving_for == :incompletion ? code_line.incompletion_points : nil
        else
          bad_index = code_line.first_invalid_character_index
          bad_char = code_line.first_invalid_character
          expected_char = code_line.next_expected_closing_bracket
          log "#{' ' * bad_index}^"
          log "Expected '#{expected_char}' at index #{bad_index}, but found '#{bad_char}' instead"
          log "#{code_line.invalidity_points} invalidity points"
          solving_for == :invalidity ? code_line.invalidity_points : nil
        end
      end.compact

    solving_for == :invalidity \
      ? score_list.sum
      : score_list.sort[score_list.length / 2]
  end
end
