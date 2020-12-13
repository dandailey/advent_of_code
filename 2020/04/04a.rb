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

IO.read('input.txt').split("\n\n").each do|raw_passport_entry|
  passport = Passport.new(raw_passport_entry)
  valid_passport_count += 1 if passport.valid?
end

puts "#{valid_passport_count} valid passports"