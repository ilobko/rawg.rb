# frozen_string_literal: true

describe RAWG::Utils do
  subject(:dummy_object) { dummy_class.new }

  let(:dummy_class) { Class.new.include(described_class) }
  let(:initializer) { proc { @foo = 'foo' } }

  describe '#lazy_attr_reader' do
    before { dummy_class.lazy_attr_reader(:foo, init: initializer) }

    it { is_expected.to have_attr_reader(:foo) }

    it 'calls init' do
      expect { dummy_object.foo }
        .to change { dummy_object.instance_variable_get('@foo') }.from(nil).to('foo')
    end
  end

  describe '#lazy_attr_accessor' do
    before { dummy_class.lazy_attr_accessor(:foo, init: initializer) }

    it { is_expected.to have_attr_accessor(:foo) }

    it 'calls init' do
      expect { dummy_object.foo }
        .to change { dummy_object.instance_variable_get('@foo') }.from(nil).to('foo')
    end
  end
end
