module ClockStore
  module_function
  def clocks
    @clocks ||= []
  end

  def add(clock)
    clocks.push(clock)
  end

  def clear
    @clocks = []
  end

  def find(id)
    clocks.find { |clock| clock.id == id}
  end

  def delete(id)
    clocks.delete_if { |clock| clock.id == id }
  end

  def as_json
    clocks.map(&:as_json)
  end
end
