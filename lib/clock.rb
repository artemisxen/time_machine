module Clock
  module_function
  def clocks
    @clocks ||= []
  end

  def add_clock
    @clocks.push({ time: Time.now, id: SecureRandom.uuid })
  end

  def clear_clocks
    @clocks = []
  end
end
