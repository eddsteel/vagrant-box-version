module VagrantBoxVersion

  class Config < Vagrant.plugin("2", :config)
    attr_accessor :url

    def initialize()
      @url = UNSET_VALUE
    end

    def finalize!
      @url = "" if @url == UNSET_VALUE
    end

    def validate(machine)
        {}
    end
  end
end
