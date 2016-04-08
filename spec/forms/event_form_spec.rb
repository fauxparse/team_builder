require 'rails_helper'

describe EventForm do
  let(:form) do
    EventForm.new(event, make_params(params))
      .on(:success) { result.success! }
      .on(:failure) { result.failure! }
  end

  let(:good_params) do
    {
      event: {
        name: "A Fancy Party",
        starts_at: "1980-07-27T00:00:00+12:00",
        duration: 86400,
        repeat_type: "yearly_by_date"
      }
    }
  end

  let(:bad_params) do
    {
      event: {
        name: "",
        duration: 86400,
        repeat_type: "sporadically"
      }
    }
  end

  let(:result) { double }

  before do
    allow(result).to receive(:success!)
    allow(result).to receive(:failure!)
  end

  def make_params(params)
    ActionController::Parameters.new(params)
  end

  context 'for a new event' do
    let(:event) { Event.new(team: FactoryGirl.create(:team)) }

    describe '#save' do
      context 'with good parameters' do
        let(:params) { good_params }

        it 'is successful' do
          expect(result).to receive(:success!)
          expect(result).not_to receive(:failure!)
          form.save
        end

        it 'has no errors' do
          form.save
          expect(event.errors).to be_empty
        end

        it 'creates an event' do
          expect { form.save }
            .to change { Event.count }.by(1)
        end

        it 'creates a recurrence rule' do
          expect { form.save }
            .to change { Event::RecurrenceRule.count }.by(1)
        end
      end

      context 'with bad parameters' do
        let(:params) { bad_params }

        it 'fails' do
          expect(result).not_to receive(:success!)
          expect(result).to receive(:failure!)
          form.save
        end

        it 'has an error on name' do
          form.save
          expect(form.errors[:name]).to eq ["can’t be blank"]
        end

        it 'has an error on repeat_type' do
          form.save
          expect(form.errors[:repeat_type]).to eq ["is invalid"]
        end

        it 'generates full error messages' do
          form.save
          expect(form.as_json[:errors])
            .to eq({
              name: ["Event name can’t be blank"],
              slug: ["URL can’t be blank"],
              repeat_type: ["Repeat type is invalid"]
            })
        end
      end
    end
  end

  context 'for an existing event' do
    let(:event) { FactoryGirl.create(:event, :weekly) }
    let(:params) { good_params }

    before { event }

    describe '#save' do
      context 'with good parameters' do
        it 'updates the event name' do
          expect { form.save }
            .to change { Event.first.name }
            .from("An Awakening")
            .to("A Fancy Party")
        end

        it 'updates the repeat type' do
          expect { form.save }
            .to change { Event::RecurrenceRule.first.repeat_type }
            .from("weekly")
            .to("yearly_by_date")
        end

        it 'does not update the event slug' do
          expect { form.save }
            .not_to change { Event.first.slug }
        end

        it 'does not create a new event' do
          expect { form.save }
            .not_to change { Event.count }
        end

        it 'does not create a new recurrence rule' do
          expect { form.save }
            .not_to change { Event::RecurrenceRule.count }
        end
      end
    end
  end
end
