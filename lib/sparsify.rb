# encoding: utf-8

module Sparsify

  def self.sparse(hash)
    result = {}

    hash.each do |key, value|
      if value.is_a?(Hash)
        prefixed = prefix_keys(key, value)
        result.merge!(prefixed)
      else
        result[key] = value
      end
    end

    result
  end

  def self.prefix_keys(prefix, hash)
    result = {}
    
    hash.each do |key, value|
      if value.is_a?(Hash)
        prefixed = prefix_keys(key, value)
        prefixed.each do |k, v|
          result["#{prefix}.#{k}"] = v
        end
      else
        result["#{prefix}.#{key}"] = value
      end

    end

    result
  end

  def self.unsparse(hash)
    result = {}

    hash.each do |key, value|
      if key.include?(".")
        insert_value(result, key.split("."), value)
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
