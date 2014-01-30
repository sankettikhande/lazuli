module Cacheable
  def self.included(base)
    base.extend(ClassMethods)
    
    ## CREATING CACHED VERSIONS FOR ASSOCIATIONS

    reflections_arr = base.reflections.keys.map(&:to_s)
    reflections_arr.each do |r|
      define_method("cached_#{r}"){
        Rails.cache.fetch([self, r]) { self.send(r) }
      }
    end

    ## EXPIRE CACHE AFTER COMMIT
    base.after_commit :flush_cache
    # base.after_touch :flush_cache
  end

  def flush_cache
    Rails.cache.delete([self.class.name, id])
    reflections_arr = self.class.reflections.keys.map(&:to_s)
    reflections_arr.each do |r|
      Rails.cache.delete([self, r])
    end
    Rails.cache.delete(self.class.name)
    Rails.cache.delete([self.class.name, "Published"])
    Rails.cache.delete_matched("#{self.class.name}_Published_")
  end

  module ClassMethods
    def cached_find(id)
      Rails.cache.fetch([name, id]) { find(id) }
    end

    def cached_all
      Rails.cache.fetch(name) {all}
    end

    def cached_published_all(limit=nil)
      if limit
        Rails.cache.fetch("#{name}_Published_#{limit}") { where(:status => "Published").order('created_at').limit(limit).all }
      else
        Rails.cache.fetch([name, "Published"]) { where(:status => "Published").all }
      end
    end
  end
end
