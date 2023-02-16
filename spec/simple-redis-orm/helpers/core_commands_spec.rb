# rubocop:disable RSpec/FilePath
module SimpleRedisOrm
  module Helpers
    RSpec.describe CoreCommands do
      let(:subject_class) do
        Class.new(Dry::Struct) do
          include CoreCommands
          extend CoreCommands::ClassMethods

          attribute :key, Types::String

          def redis
            self.class.redis
          end

          class << self
            def redis
              @redis ||= MockRedis.new
            end
          end
        end
      end

      let(:key) { 'some-key' }
      let(:field) { :field }
      let(:field_value) { 'some-value' }
      let(:hash_value) { { field => field_value } }
      let(:other_field) { :other_field }
      let(:other_value) { 'other_value' }
      let(:instance) { subject_class.new(key: key) }

      subject(:redis_command) do
        instance.set_hash(hash_value)
        instance
      end

      describe 'ClassMethods' do
        describe '.read_value' do
          before { instance.set(other_value) }

          it 'returns set simple value' do
            actual = subject_class.read_value(key)

            expect(actual).to eql(other_value)
          end
        end

        describe '.read_hash' do
          it 'returns original hash value' do
            redis_command

            expect(subject_class.read_hash(key)).to eql(hash_value)
          end
        end

        describe '.read_by' do
          it 'returns original hash value' do
            redis_command

            expect(subject_class.read_by(key)).to eql(hash_value)
          end

          context 'with unexpected key' do
            it 'returns original hash value' do
              expect(subject_class.read_by('some-other-key')).to be_nil
            end
          end
        end
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
