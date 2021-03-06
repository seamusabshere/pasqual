require 'spec_helper'
require 'securerandom'
require 'pasqual/database'

describe Pasqual::Database do
  let(:database) { Pasqual::Database.new ENV['DATABASE_URL'] }

  describe '#createdb' do
    let(:name) { SecureRandom.hex(10) }

    after :each do
      database.dropdb name
    end

    it 'creates a database' do
      expect(database.createdb(name)).to be true
    end

    it 'raises an error if a database already exists' do
      database.createdb name

      expect do
        database.createdb name
      end.to raise_error(Pasqual::Createdb::AlreadyExists)
    end

  end

  describe '#command' do
    before { database.createdb rescue Pasqual::Dropdb::Failed }

    it 'runs an sql command' do
      expect do
        database.command "SELECT 0;"
      end.to_not raise_error
    end

  end

  describe '#pipe_sql' do
    before { database.createdb rescue Pasqual::Dropdb::Failed }

    it 'runs an sql script file' do
      file = Tempfile.new 'sql-script'
      file.puts "SELECT 0;"

      expect do
        database.pipe_sql file.path
      end.to_not raise_error
    end

  end

end

