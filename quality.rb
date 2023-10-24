# frozen_string_literal: true

class Quality
  attr_accessor :name, :weight, :prices, :expected_value

  def initialize(name:, weight:, prices:)
    @name = name
    @weight = weight
    @prices = prices
  end

  def mean_price
    return @mean_price if defined?(@mean_price)

    selection = prices
                .reject(&:corrupted)
                .reject { |p| p.level == 20 }
                .reject { |p| p.quality == 20 }

    @mean_price = (
      if selection.empty?
        0
      else
        selection.sum(&:chaos_value).to_i / selection.count.to_f
      end
    )
  end

  def to_s
    "
      name: #{name}
      weight: #{weight}
      expected_value: #{expected_value}
      mean_price: #{mean_price}
    "
  end
end
