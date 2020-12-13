class PassportList
  attr_accessor :passport_list

  def initialize; @passport_list = []; end

  def load_from_file(filename)
    IO.read(filename).split("\n\n").each do|raw_passport_entry|
      @passport_list << Passport.new(raw_passport_entry)
    end
  end
end

class Passport
  attr_accessor :fieldpairs

  def initialize(raw_passport_entry)
    @fieldpairs = self.class.parse_raw_data(raw_passport_entry)
  end

  def self.parse_raw_data(raw_passport_entry)
    raw_passport_entry.
      gsub("\n", ' '). # condense to single line
      split(' ').
      map { |pair| pair.split(':') }
  end

  def valid?
    required_fields = %w[byr iyr eyr hgt hcl ecl pid]
    optional_fields = %w[cid]
    fields_in_use = @fieldpairs.map(&:first).uniq
    required_fields_in_use = fields_in_use & required_fields
    required_fields_in_use.length == required_fields.length
  end
end


valid_passport_count = 0

passport_list = PassportList.new
passport_list.load_from_file('input.txt')

passport_list.passport_list.each do |passport|
  valid_passport_count += 1 if passport.valid?
end

puts "#{valid_passport_count} valid passports"