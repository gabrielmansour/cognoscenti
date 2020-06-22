RSpec.shared_examples_for 'url field' do |field|
  context field do
    context 'when blank' do
      before do
        subject[field] = ''
        subject.valid?
      end
      it { is_expected.to be_invalid }
      it { expect(subject.errors[field]).to include 'is invalid' }
    end

    context 'when is a URL' do
      before do
        subject[field] = 'https://www.example.com/ok.html?key[]=value'
        subject.valid?
      end
      it { is_expected.to be_valid }
      it { expect(subject.errors[field]).to be_blank }
    end

    context 'when is not a URL' do
      before do
        subject[field] = 'example.com'
        subject.valid?
      end
      it { is_expected.to be_invalid }
      it { expect(subject.errors[field]).to include 'is invalid' }
    end
  end
end
