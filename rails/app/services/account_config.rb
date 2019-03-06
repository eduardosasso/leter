class AccountConfig
  DEFAULT_CONFIG = YAML.load_file("#{Rails.root}/config/leter.yml")

  def initialize(config = {})
    @config = config.transform_keys(&:to_sym)
  end

  def theme
    @config[:theme] || 'default'
  end

  def google_analytics
    @config[:google_analytics]
  end

  #TODO date format for blog posts
  def date_format
    @config[:date_format]
  end

  def pro?
    #TODO inject come from somewhere?
    false
  end

  def self.default
    new(DEFAULT_CONFIG)
  end
end
