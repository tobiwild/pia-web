# pia-web

Small web interface for starting/stopping systemd services for VPN connections to privateinternetaccess.com. It works with the service files created by https://github.com/pschmitt/pia-tools

![Screenshot](screenshot.png?raw=true)

## Installation

You need https://github.com/pschmitt/pia-tools and systemd.

    git clone https://github.com/tobiwild/pia-web
    cd pia-web
    bundle install

## Usage

Just start the web server like so:

    rackup

Then navigate to http://localhost:9292/

Die App needs to execute some commands with super user privileges:

    sudo systemctl start pia@Germany.service
    sudo systemctl stop pia@Germany.service
    ...

The user running the web app should have an entry in `/etc/sudoers` to run them without a password:

    myuser ALL = NOPASSWD: /usr/bin/systemctl start pia@*.service, /usr/bin/systemctl stop pia@*.service

However, using wildcards here is a bad idea, the above would also allow to run the following:

    sudo systemctl start pia@Germany.service httpd.service

To prevent this issue there is a wrapper script in `bin/systemctl` which validates the arguments:

    $ ./bin/systemctl start pia@Germany.service httpd.service
    
    ERROR: wrong number of arguments
    USAGE: ./systemctl [start|stop] pia@[NAME].service

Just make the command passwordless in sudoers file:

    myuser ALL = NOPASSWD: /path/to/pia-web/bin/systemctl

And tell the app to use it:

    SYSTEMCTL_PATH=/path/to/pia-web/bin/systemctl rackup
