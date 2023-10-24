# frozen_string_literal: true

require 'json'
require 'pry'
require 'net/http'
require './skill'

gem_data = JSON.parse(File.read('./gem_weights.json'))
gem_prices = JSON.parse(Net::HTTP.get(URI('https://poe.ninja/api/data/itemoverview?league=Ancestor&type=SkillGem&language=en')))
currency = JSON.parse(Net::HTTP.get(URI('https://poe.ninja/api/data/currencyoverview?league=Ancestor&type=Currency')))

currencies = {}
currency['lines'].select { |c| c['currencyTypeName'].include?('Regrading') }.each do |c|
  currencies[c['currencyTypeName']] = c['chaosEquivalent']
end

skills = gem_data.map do |name, qualities|
  Skill.new(
    name: name,
    qualities: qualities,
    support: name.include?('Support'),
    lines: gem_prices['lines'].select { |line| line['name'].include?(name) },
    lens_price: name.include?('Support') ? currencies['Secondary Regrading Lens'] : currencies['Prime Regrading Lens']
  )
end

skills
  .select { |s| s.qualities.any? { |q| q.expected_value.positive? } }
  .sort { |a, b| b.qualities.map(&:expected_value).max <=> a.qualities.map(&:expected_value).max }.each do |skill|
    puts '_' * 10
    puts skill.name
    skill
      .qualities
      # .select { |q| q.expected_value.positive? }
      .sort { |a, b| b.expected_value <=> a.expected_value }
      .each do |q|
        puts q
      end
  end

binding.pry
