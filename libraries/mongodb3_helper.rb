module Mongodb3Helper
  def mongodb_config(config)
    config.to_hash.compact.to_yaml
  end
end

class Hash
  def compact
    inject({}) do |new_hash, (k, v)|
      new_hash[k] = v.is_a?(Hash) ? v.compact : v unless v.nil?
      new_hash
    end
  end
end
