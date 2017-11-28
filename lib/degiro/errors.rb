module DeGiro
  class MissingSessionIdError < StandardError; end

  class MissingUrlError < StandardError; end
  class IncorrectUrlError < StandardError; end

  class MissingUserFieldError < StandardError; end
  class IncorrectUserFieldError < StandardError; end
end
