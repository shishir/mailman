require_relative("../test_helper")
class TestCircuitBreaker < Minitest::Test
  class MockHttpClient
    def post
    end
  end

  def test_when_circuit_is_closed
    mock_api = Minitest::Mock.new
    mock_api.expect :post, nil
    f = ->(args) {mock_api.post}
    cb = CircuitBreaker.new &f
    cb.call({})
    mock_api.verify
  end

  def test_should_trip_if_there_is_a_timeout
    f = ->(args) {raise Timeout::Error.new("I will time out.")}
    cb = CircuitBreaker.new &f
    assert_raises CircuitBreakerOpen do
      cb.call({})
    end
    assert_equal :open, cb.state
  end

  def test_should_raise_exection_if_circuit_breaker_is_open
    mock_api = MockHttpClient.new
    f = ->(args) {mock_api.post}
    cb = CircuitBreaker.new(&f)

    assert_raises CircuitBreakerOpen do
      mock_api.stub :post, ->{raise Timeout::Error.new("I will time out.")} do
        cb.call({})
      end
    end
    assert_equal :open, cb.state
    assert_raises CircuitBreakerOpen do
      cb.call({})
    end
  end


  def test_should_retry_if_circuit_is_open_after_5_minutes
    mock_api = MockHttpClient.new
    f = ->(args) {mock_api.post}
    cb = CircuitBreaker.new({retry_interval: 1}, &f)

    mock_api.stub :post, ->{raise Timeout::Error.new("I will time out.")} do
      assert_raises CircuitBreakerOpen do
        cb.call({})
      end
    end
    assert_equal :open, cb.state
    sleep 1
    mock_api.stub :post, nil do
      cb.call({})
    end
    assert_equal :closed, cb.state
  end

end