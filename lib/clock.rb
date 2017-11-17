class Clock
  attr_reader :id, :counter, :fake_time, :counter

  def initialize
    @id = generate_id
    @counter = 0
  end

  def current_time
    Time.now
  end

  def time
    @fake_time && @counter > 0 ? @fake_time : current_time
  end

  def set_fake_time(timestamp, counter)
    @fake_time = timestamp#
    @counter = counter.to_i
  end

  def reduce_counter
    @counter -= 1 unless @counter == 0
  end

  def as_json
    { id: id, time: time, counter: counter }
  end

  private

  def generate_id
    SecureRandom.uuid
  end

end
