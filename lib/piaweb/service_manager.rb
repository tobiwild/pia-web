require 'shellwords'

module PiaWeb
  class ServiceManagerException < StandardError
  end

  # Manages OpenVPN services
  class ServiceManager
    def initialize
      @vpn_dir = '/etc/openvpn/pia/'
    end

    def services
      Dir.glob(File.join(@vpn_dir, '*.ovpn')).sort.map do |file|
        name = File.basename(file, '.ovpn')
        Service.new(name, active?(name))
      end
    end

    def service(name)
      services.find { |s| s.name == name } ||
        raise(ServiceManagerException, "service with name #{name} not found")
    end

    def active?(name)
      active_names.include?(name)
    end

    def active_names
      @active_names ||= active_names!
    end

    def active_names!
      output = `systemctl -t service --state active list-units 'pia@*.service'`
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
      name = service(name).systemd_name
      run_command("sudo #{systemctl} #{action} #{name.shellescape}")
    end

    def run_command(command)
      return if system(command)
      raise ServiceManagerException, "#{command} was not successful"
    end

    def systemctl
      ENV['SYSTEMCTL_PATH'] || '/usr/bin/systemctl'
    end
  end
end
