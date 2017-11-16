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

  def find_clock(id)
    clocks.find { |clock| clock.id == id}
  end

  def delete_clock(id)
    clocks.delete_if { |clock| clock.id == id }
  end

  def display_clocks
    clocks.map(&:as_json)
  end
end
