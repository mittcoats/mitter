if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AKIAJDZHGQAJ5CH2UVDA'],
      :aws_secrete_access_key => ENV['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'],
    }
    config.fog_directory      = ENV['mitt-rails-tutorial-storage']
  end
end