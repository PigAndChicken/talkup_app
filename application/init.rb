folders = %w[controllers services representers views forms]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
