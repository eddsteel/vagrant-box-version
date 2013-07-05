begin
  require "vagrant"
rescue LoadError
  raise "This plugin must be run from within Vagrant."
end

if Vagrant::VERSION < "1.2.0"
  raise "This plugin is only compatible with Vagrant 1.2+"
end


module VagrantBoxVersion
  class Plugin < Vagrant.plugin("2")

    name "Vagrant Box Version Plugin"

    command "version" do
      require_relative "command"
      Command
    end

    config "version" do
      require_relative "config"
      Config
    end
  end
end
