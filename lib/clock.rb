class Clock
  attr_reader :id, :time

  def initialize
    @id = generate_id
    @time = current_time
  end

  private

  def generate_id
    SecureRandom.uuid
  end

  def current_time
    Time.now
  end

end
