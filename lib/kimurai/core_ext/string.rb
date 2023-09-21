require 'murmurhash3'

module StringToId
  refine String do
    def to_id
      MurmurHash3::V32.str_hash(self)
    end
  end
end
