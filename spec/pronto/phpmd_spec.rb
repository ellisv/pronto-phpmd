require 'spec_helper'

module Pronto
  describe Phpmd do
    let(:phpmd) { Phpmd.new(patches) }
    let(:patches) { nil }

    describe '#run' do
      subject(:run) { phpmd.run }

      context 'patches are nil' do
        it { should == [] }
      end

      context 'no patches' do
        let(:patches) { [] }
        it { should == [] }
      end

      context 'patches with a one error' do
        include_context 'test repo'

        let(:patches) { repo.diff('master') }

        it 'returns correct number of violations' do
          expect(run.count).to eql(1)
        end

        it 'returns expected error message' do
          expect(run.first.msg).to eql("Avoid unused private methods such as 'hello'.")
        end
      end
    end
  end
end
