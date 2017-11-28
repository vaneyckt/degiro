require_relative 'errors.rb'

module DeGiro
  class UserData
    USER_FIELDS = [
      'id',
      'intAccount'
    ].freeze

    def initialize(data)
      @map = USER_FIELDS.each_with_object({}) do |user_field, acc|
        raise MissingUserFieldError, "Could not find user field '#{user_field}'" unless data.key?(user_field)
        acc[user_field.gsub(/(.)([A-Z])/, '\1_\2').downcase] = data[user_field]
      end
    end

    def [](user_field)
      raise IncorrectUserFieldError, "Could not find user field '#{user_field}'" unless @map.key?(user_field)
      @map[user_field]
    end
  end
end
