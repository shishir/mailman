# Circuit breaker. subsequent request will fail fast instead of timing out when downstream system are un-responsive
# TODO: Reset circuit should have exponential backoff. Move reset logic to its own class and persist it in a common store
# so that state can be shared across consumer.

class CircuitBreaker
  attr_reader :state
  def initialize(options={}, &block)
    @circuit = block
    @state   = :closed
    @retry_interval = options[:retry_interval] || 300
  end

  def call(params={})
    case state
    when :closed
      execute params
    when :open
      retry? ? execute(params) : trip
    end
  end

  private
  def execute params
    begin
      @circuit.call params
      reset
    rescue Timeout::Error => e
      trip
    end
  end

  def retry?
    elasped_time > @retry_interval
  end

  def trip
    @state = :open
    @tripped_at = Time.now
    raise CircuitBreakerOpen
  end

  def reset
    @state = :closed
    @tripped_at = nil
  end

  def elasped_time
    Time.now - @tripped_at if @tripped_at
  end
end
class CircuitBreakerOpen < Exception;end