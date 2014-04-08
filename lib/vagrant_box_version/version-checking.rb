##
# Mix-in to do actual version checking
#

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


  module VersionChecking
    def check(machine, ui)
      if (machine.config.version.url.empty?)
        ui.warn("to use the vagrant version plugin, config.version.url must be set",
                 scope: machine.name)
      else
        box = machine.box
        unless box.nil?
          version = local_version(box.directory)
          remote = remote_version(machine.config.version.url, box.name)

          ui.info("Local version is #{version || "unknown"}", scope: machine.name)

          if (version || VersionString.new("0")) < (remote || VersionString.new("0"))
            ui.warn("Version #{remote} is available!", scope: machine.name)
            ui.info("To update, run:")
            ui.info("  vagrant destroy #{machine.name} && vagrant box remove #{box.name} #{box.provider.to_s}")
          elsif version.nil?
            ui.warn("Local version couldn't be determined. You should probably upgrade your box.", scope: machine.name)
          elsif remote.nil?
            ui.warn("Remote version couldn't be determined. Try again later.", scope: machine.name)
          else
            ui.success("You are up to date!", scope: machine.name)
          end
        else
          ui.success("There is no local box yet. Nothing to do.", scope: machine.name)
        end
      end
    end

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
