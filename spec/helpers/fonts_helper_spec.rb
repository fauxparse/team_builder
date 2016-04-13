require 'rails_helper'

describe FontsHelper do
  describe '#google_fonts_link_tag' do
    let(:base_url) { "https://fonts.googleapis.com/css" }
    after { helper.google_fonts_link_tag(*args) }

    context 'with a plain font name' do
      let(:args) { %w(Roboto) }

      it 'generates the correct tag' do
        expect(helper)
          .to receive(:stylesheet_link_tag)
          .with("#{base_url}?family=Roboto", media: "all")
      end
    end

    context 'with a font name and weight' do
      let(:args) { [{ "Roboto" => 500 }] }

      it 'generates the correct tag' do
        expect(helper)
          .to receive(:stylesheet_link_tag)
          .with("#{base_url}?family=Roboto:500", media: "all")
      end
    end

    context 'with multiple fonts' do
      let(:args) { ["Roboto Slab", { "Roboto" => 500 }] }

      it 'generates the correct tag' do
        expect(helper)
          .to receive(:stylesheet_link_tag)
          .with("#{base_url}?family=Roboto+Slab|Roboto:500", media: "all")
      end
    end
  end

  describe '#material_icons_link_tag' do
    it 'generates the correct tag' do
      expect(helper)
        .to receive(:stylesheet_link_tag)
        .with(
          "https://fonts.googleapis.com/icon?family=Material+Icons",
          media: "all"
        )
      helper.material_icons_link_tag
    end
  end
end
