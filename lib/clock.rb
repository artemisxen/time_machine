class Clock
  attr_reader :id, :counter

  def initialize
    @id = generate_id
    @counter = 0
  end

  def time
    fake_time && counter > 0 ? fake_time : current_time
  end

  def set_fake_time(timestamp, counter)
    self.fake_time = timestamp
    self.counter = counter
  end

  def reduce_counter
    self.counter -= 1 unless counter == 0
  end

  def as_json
    { id: id, time: time, counter: counter }
  end

  private
  attr_accessor :fake_time
  attr_writer :counter

  def generate_id
    SecureRandom.uuid
  end

  def current_time
    Time.now
  end

end
