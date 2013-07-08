require "vagrant"
require_relative "version-checking"

module VagrantBoxVersion
  class Command < Vagrant.plugin(2, :command)
    include VersionChecking

    def execute
      ui = @env.ui

      with_target_vms() do |machine|
        check(machine, ui)
      end
    end
  end
end
