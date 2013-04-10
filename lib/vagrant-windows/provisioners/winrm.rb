require 'tempfile'

module Vagrant
  module Provisioners
    class Winrm < Base
      class Config < Vagrant::Config::Base
        attr_accessor :inline

        def validate(env, errors)
          # Validate that the parameters are properly set
          if !inline
            errors.add("No inline set")
          end
        end
      end

      def self.config_class
        Config
      end

      def provision!
        env[:vm].channel.sudo(config.inline) do |type, data|
          if [:stderr, :stdout].include?(type)
            # Output the data with the proper color based on the stream.
            color = type == :stdout ? :green : :red

            # Note: Be sure to chomp the data to avoid the newlines that the
            # Chef outputs.
            env[:ui].info(data.chomp, :color => color, :prefix => false)
          end
        end
      end
    end
  end
end
