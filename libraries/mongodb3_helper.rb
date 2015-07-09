
module Mongodb3Helper
  def mongodb_config(config)
    config_hash = config.to_hash
    config_hash.compact
    JSON.parse(config_hash.dup.to_json).to_yaml
  end
end

class Hash
  def compact
    delete_if {|k,v| v.is_a?(Hash) ? v.compact.empty? : v.nil? }
  end
end
