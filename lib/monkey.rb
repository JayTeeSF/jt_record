module Monkey
  def self.patch
    Object.class_eval do
      def present?
        result = true
        if respond_to?(:nil?)
          result = result && !nil?
        end
        if respond_to?(:blank?)
          result = result && !blank?
        end
        if respond_to?(:empty?)
          result = result && !empty?
        end
        return result
      end
    end
  end
end
