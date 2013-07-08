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

    # thanks to
    # https://github.com/tknerr/vagrant-plugin-bundler/blob/master/lib/vagrant-plugin-bundler/plugin.rb

    check_version_hook = lambda do |hook|
      require_relative "action"
      hook.before Vagrant::Action::Builtin::Provision, VagrantBoxVersion::Action::Check
    end

    action_hook 'check-box-version-on-machine-up', :machine_action_up, &check_version_hook
    action_hook 'check-box-version-on-machine-reload', :machine_action_reload, &check_version_hook
    action_hook 'check-box-version-on-machine-provision', :machine_action_provision, &check_version_hook
  end
end
