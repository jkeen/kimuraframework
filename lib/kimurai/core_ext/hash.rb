module DeepMergeExclude
  refine Hash do
    def deep_merge_excl(other, exclude)
      self.merge(other.slice(*exclude)).deep_merge(other.except(*exclude))
    end
  end
end
