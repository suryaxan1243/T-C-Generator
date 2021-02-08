require 'rspec'
require_relative '../../lib/template'

RSpec.describe Template do

  describe '#generate_document' do
    let(:tempfile) { Tempfile.new }
    let(:path) { tempfile.path }
    let(:clauses) do
      [{ 'id' => 1, 'text' => 'Hurray' }, { 'id' => 2, 'text' => 'It worked' }]
    end
    let(:sections) { [{ 'id' => 1, 'clauses_ids' => [1, 2] }] }

    context 'when dataset is sufficient' do
      it 'should generate the document replacing the tags' do
        tempfile.write('[CLAUSE-1], [SECTION-1]')
        tempfile.close
        doc = Template.new(path, clauses, sections).generate_document
        expect(doc).to be_instance_of(Document)
        expect(File.read(doc.path)).to eq('Hurray, Hurray;It worked')
      end
    end

    context 'when dataset is insufficient' do
      it 'should generate document with some tags not replaced' do
        tempfile.write('[CLAUSE-3]')
        tempfile.close
        doc = Template.new(path, clauses, sections).generate_document
        expect(doc).to be_instance_of(Document)
        expect(File.read(doc.path)).to eq('[CLAUSE-3]')
      end
    end
  end
end