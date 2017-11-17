class Clock
  attr_reader :id, :counter, :fake_time, :counter

  def initialize
    @id = generate_id
  end

  def current_time
    Time.now
  end

  def time
    @fake_time || current_time
  end

  def set_fake_time(timestamp, counter)
    @fake_time = timestamp#
    @counter = counter
  end

  def as_json
    { id: id, time: time }
  end

  private

  def generate_id
    SecureRandom.uuid
  end

end
