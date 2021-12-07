Integer.define_method :triangular do
  (self * (self + 1)) / 2
end

class Solver
  def h_position_list; @h_position_list ||= input.split(',').map(&:to_i); end

  def best_h_position
    @best_h_position ||= nil
    if @best_h_position.nil?
      best_known_position = nil
      fuel_for_best_known = nil

      (h_position_list.min..h_position_list.max).each do |h_pos|
        fuel_used = fuel_used_to_align_at(h_pos)
        log "Best known: #{best_known_position}, Best fuel: #{fuel_for_best_known}, h_pos: #{h_pos}, fuel: #{fuel_used}"
        break if ! fuel_for_best_known.nil? && fuel_used > fuel_for_best_known
        best_known_position = h_pos
        fuel_for_best_known = fuel_used
      end
      @best_h_position = best_known_position
    end
    @best_h_position
  end

  def fuel_used_to_align_at(h_pos)
    h_position_list.map{ |v| (v - h_pos).abs.triangular }.sum
  end

  def calculate_answer
    fuel_used_to_align_at best_h_position
  end
end
