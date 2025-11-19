module Clickhouse
  class Base < ActiveRecord::Base
    self.abstract_class = true
    
    establish_connection(
      adapter: 'clickhouse',
      host: Rails.application.config_for(:clickhouse)['host'],
      port: Rails.application.config_for(:clickhouse)['port'],
      database: Rails.application.config_for(:clickhouse)['database'],
      username: Rails.application.config_for(:clickhouse)['username'],
      password: Rails.application.config_for(:clickhouse)['password']
    )
  end
end
