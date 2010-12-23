module ActivityPeriod

  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def has_active_period
      send :include, InstanceMethods
    end

    def active(on_date=nil)
      on_date ||= Date.today
      cond = '(active_from IS NULL AND active_to IS NULL) OR (active_from <= ? AND active_to >= ?) OR (active_from <= ? AND active_to IS NULL) or (active_from IS NULL AND active_to >= ?)'
      self.where(cond, on_date, on_date, on_date, on_date)
    end

    #TODO: add active_to >= active_from validation
  end

  module InstanceMethods
    def is_active?(on_date=nil)
      on_date ||= Date.today
      return true if self.active_from.nil? && self.active_to.nil?
      if self.active_to.nil?
        return self.active_from <= on_date
      end
      if self.active_from.nil?
        return self.active_to >= on_date
      end
      return self.active_from <= on_date && self.active_to >= on_date
    end
  end

end

ActiveRecord::Base.send :include, ActivityPeriod
