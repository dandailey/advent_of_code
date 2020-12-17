class Advent
  def self.input; IO.read('input.txt'); end

  def self.sample_input
    <<-HEREDOC
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
HEREDOC
  end

  def self.print_answer
    bag_list = {}
    input.split("\n").each do |raw_bag_rule|
      bag = Bag.new(raw_bag_rule)
      bag_list[bag.color] = bag
    end

    target_bag_color = 'shiny gold'
    valid_container_count = 0
    bag_list.each do |bag_color, bag|
      if recursive_bag_list_check bag_list, bag, target_bag_color
        valid_container_count += 1
      end
    end
    puts "ADVENT ANSWER: #{valid_container_count}"
  end

  def self.recursive_bag_list_check(bag_list, bag, bag_color)
    if bag.sub_bag_list.include? bag_color
      true
    elsif bag.sub_bag_list == 'no other bags'
      false
    else
      bag.sub_bag_list.split(', ').each do |sub_bag|
        if matches = sub_bag.match(/[0-9]+ (.*) bag/)
          if recursive_bag_list_check(bag_list, bag_list[matches[1]], bag_color)
            return true
          end
        end
      end
      false
    end
  end
end

class Bag
  attr_accessor :raw_bag_rule
  attr_accessor :color, :sub_bag_list

  def initialize(raw_bag_rule)
    @raw_bag_rule = raw_bag_rule
    parse_raw_bag_rule
  end

  def parse_raw_bag_rule
    if parts = raw_bag_rule.match(/^(.+) bags contain (.*).$/)
      @color, @sub_bag_list = parts[1], parts[2]
    else
      raise 'BAD BAG RULE'
    end
  end

  def directly_contains?(bag_color)
    sub_bag_list.include? bag_color
  end
end

Advent.print_answer