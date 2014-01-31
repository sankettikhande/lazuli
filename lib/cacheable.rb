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
    Rails.cache.delete_matched([self.class.name, id].join('_'))
  end

  module ClassMethods
    def cached_find(id, options={})
      Rails.cache.fetch([name, id, options].join('_')) { 
        options[:include].present? ? find(id, :include => options[:include]) : find(id) 
      }
    end

    def cached_all
      Rails.cache.fetch(name) {all}
    end

    def cached_scope(scope, options={})
      Rails.cache.fetch([self.class.name, scope, options]) { 
        options[:limit].present? ? send(scope).limit(options[:limit]) : send(scope) 
      }
    end
  end
end
