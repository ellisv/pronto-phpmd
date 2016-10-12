$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'fileutils'
require 'rspec'
require 'pronto/phpmd'

RSpec.shared_context 'test repo' do
  let(:git) { 'spec/fixtures/test/git' }
  let(:dot_git) { 'spec/fixtures/test/.git' }

  before { FileUtils.mv(git, dot_git) }
  let(:repo) { Pronto::Git::Repository.new('spec/fixtures/test') }
  after { FileUtils.mv(dot_git, git) }
end
