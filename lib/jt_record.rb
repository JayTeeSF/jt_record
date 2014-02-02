require_relative 'monkey'
require_relative 'id_generator'
module JTRecord

  def self.included(klass)
    klass.extend ClassMethods

    klass.class_eval do
      attr_reader :id
    end
    Monkey.patch
  end

  def save
    unless @id
      @id = self.class.generator.next
    end
    result = store( id, self )
    #puts "saved: #{self.inspect}."
    return result
  end

  def store(key, value)
    self.class.repository[key] = value
  end

  def update_attributes( attrs={} )
    set_attributes( attrs )
    save
  end

  def set_attributes( attrs={} )
    self.class.accessible_attrs.each do |attr|
      instance_variable_set( "@#{attr}", attrs.delete(attr.to_sym) || attrs.delete(attr) )
    end
  end

  #def present?
  #  true
  #end

  module ClassMethods
    # FIXME: apply conditionals
    def destroy_all(conditionals={})
      repository.clear
    end

    def where(conditionals={})
      kv_hash = repository.select{|obj_id, obj|
        conditionals.all?{|search_key, search_value|
          if ["id", :id].include?(search_key)
            search_value == obj_id
          else
            obj.respond_to?(search_key) && obj.send(search_key) == search_value
          end
        }
      }
      got = kv_hash.values
      case got.length
      when 1
        got.first
      when 0
        nil
      else
        got
      end
    end

    def generator
      unless @generator
        @generator = IdGenerator.new
      end
      @generator
    end

    def repository
      unless @repository
        @repository = {}
      end
      @repository
    end

    def accessible_attrs
      @accessible_attrs || []
    end

    def attr_accessible(*keys)
      @accessible_attrs = keys || []
      @accessible_attrs.each do |attr|
        self.class_eval do
          attr_accessor attr
        end
      end
    end

    def create(attrs={}, raise_on_failure=false)
      it = new(attrs)
      unless it.save
        fail_message = "unable to save"
        if raise_on_failure
          fail(fail_message)
        else
          warn(fail_message)
        end
      end
      return it
    end

    def create!(attrs={})
      create(attrs, true)
    end
  end
end
