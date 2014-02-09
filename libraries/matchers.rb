# Matchers for ChefSpec 3

if defined?(ChefSpec)
  def install_monit_check(check)
    ChefSpec::Matchers::ResourceMatcher.new(:monit_check, :install, check)
  end

  def uninstall_monit_check(check)
    ChefSpec::Matchers::ResourceMatcher.new(:monit_check, :uninstall, check)
  end
end
