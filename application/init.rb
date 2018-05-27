folders = %w[controllers services representers views]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
