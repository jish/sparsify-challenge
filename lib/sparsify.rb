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

end
