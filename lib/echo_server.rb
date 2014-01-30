def start_echo_service
  Mercury::start_node 'EchoService', implements: %w(echo.v1) do |msg|

  end
end
