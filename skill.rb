# frozen_string_literal: true

require './price'
require './quality'

class Skill
  attr_accessor :name, :qualities, :support, :lens_price

  def initialize(name:, qualities:, support:, lines:, lens_price:)
    @name = name
    @support = support
    @qualities = qualities.map do |quality_name, weight|
      Quality.new(
        name: quality_name,
        weight: weight,
        prices: lines.select { |line| line['name'].include?(quality_name) }.map do |line|
          Price.new(line: line)
        end
      )
    end
    @lens_price = lens_price

    calculate_expected_values
  end

  def calculate_expected_values
    qualities.each do |quality|
      other_qualities = (qualities - [quality])
      total_weight = other_qualities.sum(&:weight).to_f
      quality.expected_value = (
        other_qualities.sum { |q| q.mean_price * q.weight / total_weight } - lens_price - quality.mean_price
      )
    end
  end
end
