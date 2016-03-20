require 'etc'
Etc.passwd do |user|
  Facter.add("homedir_#{user.name}".intern) do
    setcode { user.dir }
  end
end
