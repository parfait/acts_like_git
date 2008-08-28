module ActsLikeGit
  module HashExcept
    # Returns a new hash without the given keys.
    def except(*keys)
      rejected = Set.new(respond_to?(:convert_key) ? keys.map { |key| convert_key(key) } : keys)
      reject { |key,| rejected.include?(key) }
    end

    # Replaces the hash without only the given keys.
    def except!(*keys)
      replace(except(*keys))
    end
  end
end

Hash.send(
  :include, ActsLikeGit::HashExcept
) unless Hash.instance_methods.include?("except")

module ActsLikeGit
  module ArrayExtractOptions
    def extract_options!
      last.is_a?(::Hash) ? pop : {}
    end
  end
end

Array.send(
  :include, ActsLikeGit::ArrayExtractOptions
) unless Array.instance_methods.include?("extract_options!")