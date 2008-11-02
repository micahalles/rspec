module Spec
  module Matchers

    class ContainExactly #:nodoc:

      def initialize(*expecteds)
        @expecteds = expecteds
      end

      def matches?(givens)
        @givens = givens
        @extra_items = @givens.reject do |object|
          @expecteds.include?(object)
        end
        @missing_items = @expecteds.reject do |object|
          @givens.include?(object)
        end
        @extra_items.empty? and @missing_items.empty?
      end

      def failure_message
        _message
      end

      def description
        "contain exactly #{_pretty_print(@expecteds)}"
      end

      private
      def _message(maybe_not="")
        message =  "expected collection contained:  #{@expecteds.sort.inspect}\n"
        message += "actual collection contained:    #{@givens.sort.inspect}\n"
        message += "the missing elements were:      #{@missing_items.sort.inspect}\n" unless @missing_items.empty?
        message += "the extra elements were:        #{@extra_items.sort.inspect}\n" unless @extra_items.empty?
        message
      end

      def _pretty_print(array)
        result = ""
        array.each_with_index do |item, index|
          if index < (array.length - 2)
            result << "#{item.inspect}, "
          elsif index < (array.length - 1)
            result << "#{item.inspect} and "
          else
            result << "#{item.inspect}"
          end
        end
        result
      end
    end

    # :call-seq:
    #   should contain_exactly(expected)
    #
    # Passes if givens contains all of the expected regardless of order. 
    # This works for collections. Pass in multiple args  and it will only 
    # pass if all args are found in collection.
    #
    # NOTE: there is no should_not version of contain_exactly
    # 
    # == Examples
    #
    #   [1,2,3].should contain_exactly(1,2,3) # => would pass
    #   [1,2,3].should contain_exactly(2,3,1) # => would pass
    #   [1,2,3,4].should contain_exactly(1,2,3) # => would fail
    #   [1,2,3].should contain_exactly(1,2,3,4) # => would fail
    def contain_exactly(*expected)
      Matchers::ContainExactly.new(*expected)
    end
  end
end