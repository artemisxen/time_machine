module ClockStore
  module_function
  def clocks
    @clocks ||= []
  end

  def add_clock(clock)
    clocks.push(clock)
  end

  def clear_clocks
    @clocks = []
  end
end
