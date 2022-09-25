module ExtractableInterface
  RSpec.shared_examples "extractable interface" do
    it "responds to #get" do
      expect(subject).to respond_to(:get)
    end

    it "responds to #exists?" do
      expect(subject).to respond_to(:exists?)
    end

    it "responds to #cat" do
      expect(subject).to respond_to(:cat)
    end
  end
end
