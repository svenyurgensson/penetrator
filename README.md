# Penetrator

This gem aimed to help improving code reuse in ruby projects.
Highly inspired by http://github.com/makandra/modularity gem but slightly modified for supporting
conventional *super* inheritance methods chaining.
Also much of code was shamelessly borrowed from `ActiveSupport::Concern` so I should say thanks that Ruby Hackers, who wrote it.
All that what left to do for me - just to take the best from both worlds.

## Installation

Add this line to your application's Gemfile:

    gem 'penetrator'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install penetrator

## Usage
(Rails specific example)

*config/application.rb*
```ruby
    config.autoload_paths += Rails.root.join( 'app', 'traits' )
```

File: *app/controllers/traits/crudable_trait.rb*
```ruby

      module CrudableTrait
        included do
         helper_method :resource, :resources # they are will be used in views
        end
        #
        # Implementation
        public

        def index
          respond_to do |format|
            format.html { render layout: take_layout }
            format.json { render json:   resources   }
            format.js
          end
        end

        def show
          respond_to do |format|
            format.html { render layout: take_layout }
            format.json { render json:   resource    }
            format.js
          end
        end

        # ... and so on ...

        private
          def take_layout
             # ...
          end

          def resource
            @_resource ||= resource_class.find(params[:id])
          end

          def resources
            @_resources ||= resource_class.order(default_order).all
          end
       end
```

File: *app/controllers/accomodations_controller.rb*
```ruby

      class AccomodationsController < ApplicationController
        #
        # CrudableTrait assumes that this mehod exists
        private
        def resource_class
          Accomodation
        end

        behave_like "crudable"

        # Override public traits method
        def index
          if current_user.is_admin?
            # ...
          else
            super
          end
        end

        private

        # Override traits methods
        #
        def default_order
          "accomodations.name desc"
        end

        public

        # Override traits methods
        # with respecting call chaining
        #
        def kill_all_humans
          "Yes" or super
        end

      end
```

What makes this gem different from `ActiveSupport::Concern` ?
Well, here you can _parameterize_ your included modules-traits!
(Extracted from `spec/coerce_spec.rb` )

File:  *app/traits/can_have_args_trait.rb*
```ruby
    module CanHaveArgsTrait
      extend Penetrator::Concern
      included do |*args|
        args.each do |method_name|
          define_method(method_name) do
            method_name.to_s + "-chunked!"
          end
        end
      end # included
    end # CanHaveArgs
```

File:  *app/models/my_model.rb*
```ruby

    class Victim
      behaves_like :CanHaveArgs, 'arg1', 'arg2'
    end

    obj = Victim.new

    obj.arg1  # => 'arg1-chunked!'
    obj.arg2  # => 'arg2-chunked!'

```

Also you can freely utilize `ClassMethods` internal module as you usually do with `ActiveSupport::Concern`

```ruby

    module RichTrait
      extend Penetrator::Concern
      module ClassMethods
        def class_method
          ... add what you want ...
        end
      end

      def instance_method
      end
    end

```

You can even extend arbitrary instance of any class with your trait:

```ruby

    module HtmlSanitizerTrait
      extend Penetrator::Concern

      def cleanup
        ....
      end
    end

    string_of_dirty_html = "Something <span>dirty</span> and even <marquee>fearing ugly</marquee>"
    string_of_dirty_html.behave_like 'html_sanitizer'
    ...


```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
