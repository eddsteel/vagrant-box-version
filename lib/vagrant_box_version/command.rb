require "vagrant"

module VagrantBoxVersion
  require "open-uri"

  class VersionString
    attr_reader :build, :hash
    include Comparable

    def initialize(string)
      @build = string.strip[/[^-]*/]
      @hash = if string.include? "-" then string.split("-")[1] else "" end
    end

    def to_s
      "#@build-#@hash"
    end

    def <=>(other)
      build <=> other.build
    end
  end

  class Command < Vagrant.plugin(2, :command)

    def initialize(args, environment)
      @args = args
    end

    def execute
      ui = @env.ui

      with_target_vms() do |machine|
        box = machine.box
        version = local_version(box.directory)
        remote = remote_version(box.config.url, box.name)

        ui.info("Local version is #{version || "unknown"}")

        if (version || VersionString.new("0")) < (remote || VersionString.new("0"))
          ui.warn("Version #{remote} is available!")
          ui.info("To update, run:")
          ui.info("  vagrant destroy && vagrant box remove #{box.name}")
        elsif version.nil?
          ui.warn("Local version couldn't be determined. You should probably upgrade your box.")
        elsif remote.nil?
          ui.warn("Remote version couldn't be determined. Try again later.")
        else
          ui.info("You are up to date!")
        end
      else
        ui.error("Local box is unavailable. Please init")
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
