folders = %w[lib config infrastructure application]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
