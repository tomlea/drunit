module Drunit
  class RemoteError < RuntimeError

    class << self
      def name
        @name || super
      end
      attr_writer :name
    end

    def initialize(exception_name)
      @exception_name = exception_name.to_s
    end

    def class
      return type if type = look_up_exception
      super.name = @exception_name #Now we hope and prey that the name of the class is checked imidiately
      super
    end

    def look_up_exception
      @exception_name.split("::").inject(Object){|node, part|
        node && node.const_defined?(part) && node.const_get(part)
      }
    end

  end
end


