class Clock
  attr_reader :id

  def initialize
    @id = generate_id
  end

  def current_time
    Time.now
  end

  def time
    current_time
  end

  def as_json
    { id: id, time: time}
  end

  private

  def generate_id
    SecureRandom.uuid
  end

end
