# frozen_string_literal: true

class Price
  attr_accessor :level, :quality, :chaos_value, :divine_value, :corrupted, :vaal

  def initialize(line:)
    @level = line['gemLevel']
    @quality = line['gemQuality']
    @chaos_value = line['chaosValue']
    @divine_value = line['divineValue']
    @corrupted = line['corrupted'] || false
    @vaal = line['name'].downcase.include?('vaal')
  end
end
