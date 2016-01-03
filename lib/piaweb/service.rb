module PiaWeb
  # Service
  class Service
    attr_reader :name
    attr_reader :active

    def initialize(name, active)
      @name = name
      @active = active
    end

    def systemd_name
      "pia@#{@name}.service"
    end
  end
end
