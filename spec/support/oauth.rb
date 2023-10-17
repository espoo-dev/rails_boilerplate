def mock_omni_auth(key, mock)
  allow(OmniAuth.config).to receive(:test_mode).and_return true
  # Passthrough all the key's we're not mocking (e.g. :default)
  allow(OmniAuth.config.mock_auth).to receive(:[]).and_call_original
  # Mock the one we want to fully control
  allow(OmniAuth.config.mock_auth)
    .to receive(:[]).with(key).and_return(mock)
end
