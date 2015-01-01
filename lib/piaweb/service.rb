module PiaWeb
  class Service

    attr_reader :name
    attr_reader :active

    def initialize(name, active)
      @name = name
      @active = active
    end

  end
end
