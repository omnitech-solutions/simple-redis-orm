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

      # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
      def deserialize_hash_value(hash)
        return if hash.nil?

        hash.transform_values do |v|
          next v if v.nil?
          next v unless v.is_a?(String)
          next v unless v.encoding == Encoding::ASCII_8BIT

          v.strip.empty? ? v : MessagePack.unpack(v)
        rescue StandardError => e
          next without_invalid_characters(v) if e.instance_of?(ArgumentError)

          raise e
        end.deep_symbolize_keys
      end
      # rubocop:enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

      private

      def without_invalid_characters(text)
        return text unless text.is_a?(String)

        text.chars.select(&:valid_encoding?).join
      end
    end
  end
end
