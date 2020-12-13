class Passport
  attr_accessor :fieldpairs

  REQUIRED_FIELDS = %w[byr iyr eyr hgt hcl ecl pid]

  def initialize(raw_passport_entry)
    @fieldpairs = self.class.parse_raw_data(raw_passport_entry)
  end

  def self.parse_raw_data(raw_passport_entry)
    raw_passport_entry.
      gsub("\n", ' '). # condense to single line
      split(' ').
      map { |pair| pair.split(':') }
  end

  def value_for(fieldname)
    first_pair = @fieldpairs.select{ |pair| pair.first == fieldname.to_s }.first
    first_pair ? first_pair.last : nil
  end

  def valid?
    # return false unless contains_all_required_fields?
    REQUIRED_FIELDS.each do |fieldname|
      return false unless send("#{fieldname}_valid?")
    end
  end

  # def contains_all_required_fields?
  #   fields_in_use = @fieldpairs.map(&:first).uniq
  #   required_fields_in_use = fields_in_use & REQUIRED_FIELDS
  #   required_fields_in_use.length == REQUIRED_FIELDS.length
  # end

# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.

  def byr_valid?
    v = value_for(:byr)
    v && v.match(/^\d{4}$/) && (1920..2002) === v.to_i
  end

  def iyr_valid?
    v = value_for(:iyr)
    v && v.match(/^\d{4}$/) && (2010..2020) === v.to_i
  end

  def eyr_valid?
    v = value_for(:eyr)
    v && v.match(/^\d{4}$/) && (2020..2030) === v.to_i
  end

  def hgt_valid?
    v = value_for(:hgt)
    return false unless v && (pieces = v.match(/^(\d+)(in|cm)$/))
    (pieces[2] == 'in' ? (59..76) : (150..193)) === pieces[1].to_i
  end

  def hcl_valid?
    v = value_for(:hcl)
    v && v.match(/^\#[0-9a-f]{6}$/)
  end

  def ecl_valid?
    v = value_for(:ecl)
    %w[amb blu brn gry grn hzl oth].include?(v)
  end

  def pid_valid?
    v = value_for(:pid)
    v && v.match(/^\d{9}$/)
  end
end

valid_passport_count = 0

IO.read('input.txt').split("\n\n").each do|raw_passport_entry|
  passport = Passport.new(raw_passport_entry)
  puts (passport.valid? ? '' : 'IN') + 'VALID: ' + passport.fieldpairs.inspect #if passport.value_for(:byr) && ! passport.byr_valid?
  valid_passport_count += 1 if passport.valid?
end

puts "#{valid_passport_count} valid passports"