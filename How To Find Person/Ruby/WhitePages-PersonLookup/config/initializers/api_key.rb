# Config file.
config_file = Rails.root.join('config', 'api_key.yml').to_s

# Load config file.
begin
  config = YAML.load(File.open(config_file))[Rails.env]
rescue
  raise "Failed to load required config: '#{config_file}'"
end

ENV['API_KEY'] = config['api_key']