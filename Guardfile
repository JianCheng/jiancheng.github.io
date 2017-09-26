# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard :shell do
  watch(%r{(.*)\.rst}) do |m|
  system("make")
  # system("sphinx-build -b html -d _build/doctrees . _build/html")
  end
end

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{.+\.(css|html|js|rst)$})
  # watch(%r{_build/.+\.(css|html|js|rst)$})
end


