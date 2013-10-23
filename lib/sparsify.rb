# encoding: utf-8

module Sparsify

  def self.sparse(hash, options = {})
    result = {}
    separator = options.fetch(:separator, ".")

    hash.each do |key, value|
      escaped = Regexp.escape(separator)
      regex = Regexp.new(escaped)
      key = key.gsub(/\\/, "\\\\\\\\")
      key = key.gsub(regex, escaped)

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
      key = key.gsub(/\\\\/, "\\")

      if key.include?(separator)
        parts = gather_parts(key, separator)
        insert_value(result, parts, value)
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

  def self.gather_parts(key, separator)
    parts = key.split(separator)
    previous_fragment = nil
    result = []

    parts.each do |part|
      if previous_fragment
        p = [previous_fragment, part].join(separator)
        result.push(p)
        previous_fragment = nil
        next
      end

      if part.match(/\\$/)
        previous_fragment = part.chop
        next
      end

      result.push(part)
    end

    result
  end

end
