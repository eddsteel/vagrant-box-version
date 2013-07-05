require "vagrant"

module VagrantBoxVersion
  require "open-uri"

  class VersionString
    attr_reader :build, :hash
    include Comparable

    def initialize(string)
      @build = string.strip[/[^-]*/].to_i
      @hash = if string.include? "-" then string.strip.split("-")[1] else "" end
    end

    def to_s
      "#@build-#@hash"
    end

    def <=>(other)
      build <=> other.build
    end
  end

  class Command < Vagrant.plugin(2, :command)

    def execute
      ui = @env.ui

      with_target_vms() do |machine|
        box = machine.box
        unless box.nil?
          version = local_version(box.directory)
          remote = remote_version(machine.config.version.url, box.name)

          ui.info("Local version is #{version || "unknown"}")

          if (version || VersionString.new("0")) < (remote || VersionString.new("0"))
            ui.warn("Version #{remote} is available!")
            ui.info("To update, run:")
            ui.info("  vagrant destroy && vagrant box remove #{box.name} #{box.provider.to_s}")
          elsif version.nil?
            ui.warn("Local version couldn't be determined. You should probably upgrade your box.")
          elsif remote.nil?
            ui.warn("Remote version couldn't be determined. Try again later.")
          else
            ui.success("You are up to date!")
          end
        else
          ui.success("There is no local box yet. Nothing to do.")
        end
      end
    end

    private

    def local_version(boxdir)
      versionfile = File.join(boxdir, "include", "version")
      if File.exists? versionfile then VersionString.new(File.read(versionfile)) else nil end
    end

    def remote_version(server, name)
      begin
        VersionString.new(open("#{server}/#{name}.box.version").read)
      rescue
        nil
      end
    end
  end
end
