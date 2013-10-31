module StatisticsConcernSpecs
shared_examples_for Statistics do
  describe "statistics" do
    let(:object) { subject }
    before do
      object.save
    end
    context "for mentor asks" do
      describe "average response" do
        it "returns difference in ask and answer creations times for one ask" do
          ask = FactoryGirl.create(:mentor_ask, created_at: 1.day.ago)
          assosciation_name = "#{object.class.name.pluralize.downcase}"
          ask.send("#{assosciation_name}=", [object])
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(object.average_response_time).to be_within(0.01).of(1)
        end
        it "returns correct value for a set of asks" do
          3.times do
            ask = FactoryGirl.create(:mentor_ask, created_at: 1.day.ago)
            assosciation_name = "#{object.class.name.pluralize.downcase}"
            ask.send("#{assosciation_name}=", [object])
            ask.create_answer(FactoryGirl.attributes_for :answer)
          end
          expect(object.average_response_time).to be_within(0.01).of(1)
        end
        it "returns '0' for an empty set of asks" do
          ask = FactoryGirl.create(:mentor_ask, created_at: 1.day.ago)
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(object.average_response_time).to eq 0
        end
      end
      describe "median response" do
        it "returns difference in ask and answer creation times for one ask" do
          ask = FactoryGirl.create(:mentor_ask, created_at: 1.day.ago)
          assosciation_name = "#{object.class.name.pluralize.downcase}"
          ask.send("#{assosciation_name}=", [object])
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(object.median_response_time).to be_within(0.01).of(1)
        end
        it "returns correct value for a set of asks" do
          3.times do
            ask = FactoryGirl.create(:mentor_ask, created_at: 1.day.ago)
            assosciation_name = "#{object.class.name.pluralize.downcase}"
            ask.send("#{assosciation_name}=", [object])
            ask.create_answer(FactoryGirl.attributes_for :answer)
          end
          expect(object.median_response_time).to be_within(0.01).of(1)
        end
        it "returns '0' for an empty set of asks" do
          ask = FactoryGirl.create(:mentor_ask, created_at: 1.day.ago)
          ask.create_answer(FactoryGirl.attributes_for(:answer))
          expect(object.median_response_time).to eq 0
        end
      end
    end
  end
end
end
