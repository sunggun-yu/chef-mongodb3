module Mongodb3Helper
  def mongodb_config(config)
    config.to_hash.compact.to_yaml
  end
end

class Hash
  def compact
    inject({}) do |new_hash, (k, v)|
      if v.is_a?(Hash)
        v = v.compact
        new_hash[k] = v unless v.empty?
      else
        new_hash[k] = v unless v.nil?
      end
      new_hash
    end
  end
end
