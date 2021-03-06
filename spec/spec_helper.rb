# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require "active_record"

require 'makara'
require 'delorean'

begin
  require 'ruby-debug'
rescue LoadError => e
end

Dir[File.join(File.dirname(__FILE__), 'support', '*.rb')].each do |file|
  require file
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.before(:each) do
    Makara::Connection::Group.any_instance.stub(:should_shuffle?).and_return(false)
  end

  config.after(:each) do
    Makara.reset!
  end

  def connect!(config)
    ActiveRecord::Base.establish_connection(config)
  end

  def adapter
    ActiveRecord::Base.connection
  end

  def simple_config
    {
      :adapter => 'makara',
      :db_adapter => 'abstract',
      :database => 'test_db',
      :host => 'localhost',
      :port => '3439',
      :connections => [
        {:name => 'master', :role => 'master'}
      ]
    }
  end

  def namespace_config
    simple_config.merge({
      :namespace => 'my_app'
    })
  end


  def single_slave_config
    simple_config.merge({
      :connections => [
        {:name => 'master', :role => 'master'},
        {:name => 'slave1'}
      ]
    })
  end

  def multi_slave_config
    simple_config.merge({
      :connections => [
        {:name => 'master', :role => 'master'},
        {:name => 'Slave One'},
        {:name => 'Slave Two'}
      ]
    })
  end

  def multi_slave_weighted_config
    simple_config.merge({
      :connections => [
        {:name => 'master', :role => 'master'},
        {:name => 'Slave One', :weight => 2},
        {:name => 'Slave Two', :weight => 3}
      ]
    })
  end

  def massive_slave_config
    simple_config.merge({
      :connections => [
        {:name => 'master', :role => 'master'},
        {:name => 'Slave One'   },
        {:name => 'Slave Two'   },
        {:name => 'Slave Three' },
        {:name => 'Slave Four'  },
        {:name => 'Slave Five'  }
      ]
    })
  end

  def invalid_config
    simple_config.merge({
      :db_adapter => 'some_unknown_adapter'
    })
  end

  def sticky_config
    simple_config.merge({
      :sticky_slave => true,
      :sticky_master => true
    })
  end

  def dry_config
    simple_config.merge({
      :sticky_slave => false,
      :sticky_master => false
    })
  end

  def dry_single_slave_config
    single_slave_config.merge({
      :sticky_slave => false,
      :sticky_master => false
    })
  end

  def dry_multi_slave_config
    multi_slave_config.merge({
      :sticky_slave => false,
      :sticky_master => false
    })
  end

end
