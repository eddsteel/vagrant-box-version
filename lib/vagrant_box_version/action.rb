require_relative "version-checking"

module VagrantBoxVersion
  module Action
    class Check
      include VersionChecking

      def initialize(app, env)
        @app = app
      end

      def call(env)
        check(env[:machine], env[:ui])
        @app.call(env)
      end
    end
  end
end
