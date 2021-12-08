class InputLine
  attr_accessor :line, :info

  SEGMENT_PATTERNS = {
    'abcefg' => 0,
    'cf' => 1,
    'acdeg' => 2,
    'acdfg' => 3,
    'bcdf' => 4,
    'abdfg' => 5,
    'abdefg' => 6,
    'acf' => 7,
    'abcdefg' => 8,
    'abcdfg' => 9,
  }

  def initialize(line); @line = line; end

  def halves; @halves ||= line.split(' | '); end
  def signal_patterns; @signal_patterns ||= halves.first.split(' '); end
  def raw_output_patterns; @raw_output_patterns ||= halves.last.split(' '); end

  def decoded_output; @decoded_output ||= decode_mixed_pattern_list(raw_output_patterns).join.to_i; end

  def signal_patterns_by_length;
    @signal_patterns_by_length ||= nil
    if @signal_patterns_by_length.nil?
      @signal_patterns_by_length = {}
      signal_patterns.each do |pattern|
        @signal_patterns_by_length[pattern.length] ||= []
        @signal_patterns_by_length[pattern.length] << pattern
      end
    end
    @signal_patterns_by_length
  end

  def possible_patterns_for(nbr)
    case nbr
    when 1 then signal_patterns_by_length[2]
    when 7 then signal_patterns_by_length[3]
    when 4 then signal_patterns_by_length[4]
    when 2, 3, 5 then signal_patterns_by_length[5]
    when 0, 6, 9 then signal_patterns_by_length[6]
    when 8 then signal_patterns_by_length[7]
    end
  end

  def segments_for_1; signal_patterns_by_length[2].first.split(''); end
  def segments_for_4; signal_patterns_by_length[4].first.split(''); end
  def segments_for_7; signal_patterns_by_length[3].first.split(''); end
  def segments_for_8; signal_patterns_by_length[7].first.split(''); end

  def segments_for_2;
    signal_patterns_by_length[5].each do |pattern|
      segments = pattern.split('')
      break segments if (segments & segments_for_4).length == 2
    end
  end

  def segments_for_adg; signal_patterns_by_length[5].map{|v| v.split('')}.inject(:&); end
  def segments_for_bcef; segments_for_8 - segments_for_adg; end
  def segments_for_eg; segments_for_8 - segments_for_4 - segments_for_7; end
  def segments_for_be; segments_for_8 - segments_for_adg - segments_for_1; end
  def segments_for_bd; segments_for_4 - segments_for_1; end
  def segments_for_cd; segments_for_2 & segments_for_4; end

  def segment_map
    @segment_map ||= {}
    if @segment_map == {}
      @segment_map['a'] = (segments_for_7 - segments_for_1).first
      @segment_map['b'] = (segments_for_bd & segments_for_be).first
      @segment_map['c'] = (segments_for_cd & segments_for_1).first
      @segment_map['d'] = (segments_for_bd & segments_for_cd).first
      @segment_map['e'] = (segments_for_be & segments_for_eg).first
      @segment_map['f'] = (segments_for_1 - [@segment_map['c']]).first
      @segment_map['g'] = (segments_for_adg - [@segment_map['a'], @segment_map['d']]).first

      @segment_map = @segment_map.invert
    end
    @segment_map
  end

  def signal_pattern_map
    @signal_pattern_map ||= {}
    if @signal_pattern_map == {}
      signal_patterns.each do |mixed_pattern|
        SEGMENT_PATTERNS.each do |correct_pattern, number|
          if mixed_pattern_to_number(mixed_pattern) == correct_pattern
            @signal_pattern_map[mixed_pattern] = correct_pattern
          end
        end
      end
    end
    @signal_pattern_map
  end

  def mixed_pattern_to_number(mixed_pattern)
    SEGMENT_PATTERNS[interpret_pattern(mixed_pattern)]
  end

  def interpret_pattern(mixed_pattern)
    mixed_pattern.split('').map{|v| segment_map[v]}.sort.join
  end

  def decode_mixed_pattern_list(mixed_pattern_list)
    mixed_pattern_list.map{|v| mixed_pattern_to_number(v)}
  end
end

class Solver
  def calculate_answer
    input_lines.map do |line_value|
      # line_value = 'acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'
      input_line = InputLine.new(line_value)

      log line_value
      log "TEST: #{input_line.mixed_pattern_to_number('acedgfb')}"
      log "segments_for_1: #{input_line.segments_for_1}"
      log "segments_for_4: #{input_line.segments_for_4}"
      log "segments_for_7: #{input_line.segments_for_7}"
      log "segments_for_8: #{input_line.segments_for_8}"
      log "segments_for_2: #{input_line.segments_for_2}"
      log "segments_for_adg: #{input_line.segments_for_adg}"
      log "segments_for_bcef: #{input_line.segments_for_bcef}"
      log "segments_for_eg: #{input_line.segments_for_eg}"
      log "segments_for_be: #{input_line.segments_for_be}"
      log "segments_for_bd: #{input_line.segments_for_bd}"
      log "segments_for_cd: #{input_line.segments_for_cd}"
      log "segment_map: #{input_line.segment_map.inspect}"
      log "signal_pattern_map: #{input_line.signal_pattern_map.inspect}"
      log "signal_patterns: #{input_line.signal_patterns.inspect}"
      log "decoded_output: #{input_line.decoded_output.inspect}"

      input_line.decoded_output
    end.sum
  end
end
