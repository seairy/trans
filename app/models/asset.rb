# -*- encoding : utf-8 -*-
class Asset < ActiveRecord::Base
  after_destroy :delete_reference_file
  
  def prepare options = {}
    stored_name = "#{Digest::MD5.hexdigest(Time.now.to_s + options[:original_filename] + rand.to_s[-8..-1])}#{options[:original_filename].scan(/\.\w+$/)[0]}"
    stored_prefix_path = "#{::Rails.root.to_s}/public/assets/#{stored_name[0..1]}"
    FileUtils.mkdir_p stored_prefix_path
    File.open("#{stored_prefix_path}/#{stored_name}", "wb") do |f|
      f.write(options[:stream])
    end
    self.original_name = options[:original_filename]
    self.stored_name = stored_name
    self.stored_path = "#{stored_prefix_path}/#{stored_name}"
    self.uri = "/assets/#{stored_name[0..1]}/#{stored_name}"
    self.content_type = options[:content_type]
    self.size = options[:size]
    self
  end
  
  def delete_reference_file
    FileUtils.rm_r self.stored_path
  end
end