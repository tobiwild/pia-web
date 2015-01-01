require 'shellwords'

module PiaWeb
  class ServiceManagerException < StandardError
  end

  class ServiceManager

    def initialize
      @vpn_dir = '/etc/openvpn/pia/'
    end

    def services
      files = Dir.glob File.join(@vpn_dir, '*.ovpn')

      result = []

      files.each do |file|
        if %r#([^/]+)\.ovpn$# === file
          result << Service.new($1, active?($1))
        end
      end

      result
    end

    def active?(name)
      active_names.include?(name)
    end

    def active_names
      @active_names ||= active_names!
    end

    def active_names!
      output = %x{systemctl -t service --state active list-units 'pia@*.service'}
      output.scan(/(?<=pia@)[^.]+/)
    end

    def activate(name)
      active_names!.each do |active_name|
        deactivate(active_name)
      end
      run_systemd('start', name)
    end

    def deactivate(name)
      run_systemd('stop', name)
    end

    private

    def run_systemd(action, name)
      service_name = "pia@#{name}.service"
      run_command("sudo systemctl #{action} #{service_name.shellescape}")
    end

    def run_command(command)
      unless system(command)
        raise ServiceManagerException.new(command + ' was not successful')
      end
    end
  end
end
