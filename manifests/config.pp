# == Class: postfix::config
#
class postfix::config {
  if $::postfix::config_dir_source {
    file { 'postfix.dir':
      ensure  => $::postfix::config_dir_ensure,
      path    => $::postfix::config_dir_path,
      force   => $::postfix::config_dir_purge,
      purge   => $::postfix::config_dir_purge,
      recurse => $::postfix::config_dir_recurse,
      source  => $::postfix::config_dir_source,
      notify  => $::postfix::config_file_notify,
      require => $::postfix::config_file_require,
    }
  }

  if $::postfix::config_file_path {
    file { 'postfix.conf':
      ensure  => $::postfix::config_file_ensure,
      path    => $::postfix::config_file_path,
      owner   => $::postfix::config_file_owner,
      group   => $::postfix::config_file_group,
      mode    => $::postfix::config_file_mode,
      source  => $::postfix::config_file_source,
      content => $::postfix::config_file_content,
      notify  => $::postfix::config_file_notify,
      require => $::postfix::config_file_require,
    }
  }

  if $::postfix::recipient {
    exec { 'postfix.newaliases':
      command     => '/usr/bin/newaliases',
      refreshonly => true,
      subscribe   => Mailalias['postfix.mailalias'],
      require     => $::postfix::config_file_require,
    }

    mailalias { 'postfix.mailalias':
      ensure    => $::postfix::config_file_ensure,
      name      => 'root',
      recipient => $::postfix::recipient,
    }
  }
}
