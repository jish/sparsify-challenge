# encoding: utf-8

module Sparsify

  def self.sparse(hash, options = {})
    result = {}
    separator = options.fetch(:separator, ".")

    hash.each do |key, value|
      if value.is_a?(Hash)
        prefixed = prefix_keys(key, value, separator)
        result.merge!(prefixed)
      else
        result[key] = value
      end
    end

    result
  end

  def self.prefix_keys(prefix, hash, separator)
    result = {}
    
    hash.each do |key, value|
      if value.is_a?(Hash) && value.keys.length > 0
        prefixed = prefix_keys(key, value, separator)
        prefixed.each do |k, v|
          result[[prefix, k].join(separator)] = v
        end
      else
        result[[prefix, key].join(separator)] = value
      end

    end

    result
  end

  def self.unsparse(hash, options = {})
    result = {}
    separator = options.fetch(:separator, ".")

    hash.each do |key, value|
      if key.include?(separator)
        insert_value(result, key.split(separator), value)
      else
        result[key] = value
      end
    end

    result
  end

  def self.insert_value(hash, parts, value)
    if parts.length > 1
      part = parts.shift
      hash[part] ||= {}
      insert_value(hash[part], parts, value)
    else
      hash[parts.first] = value
    end
  end

end
