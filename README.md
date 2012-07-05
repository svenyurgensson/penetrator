# Penetrator

This gem aimed to help with reuse code in ruby projects.
Highly inspired from http://github.com/makandra/modularity gem but slightly modified for supporting
conventional *super* inheritance chaining methods.


## Installation

Add this line to your application's Gemfile:

    gem 'penetrator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install penetrator

## Usage
(Rails specific example)

*config/application.rb*
```ruby
config.autoload_paths += Dir[Rails.root.join( 'app', '**/*' )].select { |fn| File.directory?(fn) }
```

*app/controllers/traits/crudable_trait.rb*
```ruby
        module CrudableTrait
          #
          # Implementation
          public

          def index
            @accomodation = resource
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

          # ... and so on

          private
            def take_layout
               # ...
            end

            def resource
              @_resource ||= resource_class.all
            end
         end
```

*app/controllers/accomodations_controller.rb*
```ruby
        class AccomodationsController < ApplicationController
          #
          # CrudableTrait required parameters
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
        end
```



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
