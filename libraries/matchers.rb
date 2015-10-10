# Matchers for ChefSpec 3

if defined?(ChefSpec)
  ChefSpec.define_matcher(:monit_check)

  def create_monit_check(check)
    ChefSpec::Matchers::ResourceMatcher.new(:monit_check, :create, check)
  end

  def delete_monit_check(check)
    ChefSpec::Matchers::ResourceMatcher.new(:monit_check, :delete, check)
  end

  def remove_monit_check(check)
    ChefSpec::Matchers::ResourceMatcher.new(:monit_check, :remove, check)
  end
end
