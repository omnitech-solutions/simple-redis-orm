# rubocop:disable RSpec/FilePath
#
module SimpleRedisOrm
  RSpec.describe ApplicationEntry do
    let(:subject_class) do
      Class.new(ApplicationEntry) do
        attribute :email, Types::String.optional

        class << self
          def new(id:, **attributes)
            super(id: id, **attributes.merge(email: without_redis_key_prefix(id)))
          end

          def create(email:)
            attrs = { email: email }

            new(id: email, **attrs).save
          end

          def name
            'SomeModel'
          end

          def redis
            Entry.redis
          end
        end
      end
    end

    describe '.new' do
      it 'add redis entry' do
        user = subject_class.new(id: 'desoleary@gmail.com')
        user.save

        actual = subject_class.find('desoleary@gmail.com')
        expect(actual.attributes).to eql({ email: 'desoleary@gmail.com' })
      end
    end

    describe '.create' do
      let(:email) { 'email@domain.com' }

      it 'add redis entry' do
        subject_class.create(email: email)

        user = subject_class.find(email)
        expect(user.key).to eql("some_model:#{email}")
        expect(user.id).to eql(email)
        expect(user.email).to eql(email)
      end
    end
  end
end
# rubocop:enable RSpec/FilePath
