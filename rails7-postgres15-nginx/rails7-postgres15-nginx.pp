node 'iac-examples-puppet' {

  # Update package list
  class { 'apt':
    update => {
      frequency => 'daily',
    },
    always_apt_update => true,
  }

  # Install prerequisites
  package { ['curl', 'git', 'libpq-dev', 'nodejs', 'yarn']:
    ensure => installed,
  }

  # Set up rbenv for Ruby management
  class { 'rbenv':
    install_dir => '/opt/rbenv',
    owner       => 'tlehman',
    group       => 'tlehman',
  }

  rbenv::plugin { [ 'rbenv/ruby-build', 'rbenv/rbenv-vars' ]: }

  rbenv::build { '3.1.0':
    global => true,
  }

  # Set up PostgreSQL
  class { 'postgresql::server':
    pg_hba_conf_defaults => false,
    ipv4acls             => ['host    all             all             0.0.0.0/0               md5'],
    ipv6acls             => ['host    all             all             ::/0                    md5'],
  }

  postgresql::server::db { 'rails_app_db':
    user     => 'rails_db_user',
    password => postgresql_password('rails_db_user', 'password123'),
  }

  # Install Nginx and set up server block for Rails app
  class { 'nginx': }

  nginx::resource::upstream { 'rails_app_upstream':
    members => ['unix:/path/to/your/app/tmp/unicorn.sock'],
  }

  nginx::resource::vhost { 'rails-app-domain.com':
    www_root      => '/path/to/your/app/public',
    proxy         => 'http://rails_app_upstream',
    listen_port   => 80,
    location_cfg  => {
      'proxy_set_header'  => [
        'X-Forwarded-For $proxy_add_x_forwarded_for',
        'Host $http_host',
        'X-Real-IP $remote_addr',
      ],
      'proxy_redirect' => 'off',
    },
  }

  # Note: This doesn't install Unicorn or configure Rails itself.
  # You'd need to do this as part of your Rails app deployment process.
}
