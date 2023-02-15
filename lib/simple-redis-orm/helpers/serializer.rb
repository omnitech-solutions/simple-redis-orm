module SimpleRedisOrm
  module Helpers
    module Serializer
      def serialize_value(value)
        return value if value.nil?

        MessagePack.pack(value)
      end

      def deserialize_value(value)
        return if value.nil?

        return deserialize_hash_value(value) if value.is_a?(Hash)

        MessagePack.unpack(value)
      end

      def deserialize_hash_value(hash)
        return if hash.nil?

        hash.transform_values do |v|
          begin
            next v if v.nil?
            next v unless v.is_a?(String)
            next v unless v.encoding == Encoding::ASCII_8BIT

            v.strip.empty? ? v : MessagePack.unpack(v)
          rescue => ex
            next without_invalid_characters(v) if ex.class == ArgumentError

            raise ex
          end
        end.deep_symbolize_keys
      end

      private

      def without_invalid_characters(text)
        return text unless text.is_a?(String)

        text.chars.select(&:valid_encoding?).join
      end
    end
  end
end
