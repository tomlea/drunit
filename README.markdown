# Distributed Ruby Unit (Testing)

A library for running tests across multiple applications from a single test case.


## Basic usage:

    class MainTest < Test::Unit::TestCase
      include Drunit
      RemoteApp(:fake_app, 'fake_app.rb', FAKE_APP_PATH)
      RemoteApp(:rails_app, 'script/runner', RAILS_APP_PATH)

      def test_should_use_the_same_db
        id = in_app(:fake_app){
          User.create!(:name => "Some Name")
        }

        in_app(:rails_app, id) do |id|
          assert_nothing_raised() { User.find(id) }
        end
      end
    end

## Other "features"
* Automatically "Brings Up" and "Takes Down" your apps as needed. (Uses GC to tell when it's no longer needed.)
* Tracking of assertion counts.
* Beautified (a little) backtraces.
* Line number preserving between apps.
* Packed full of bugs (probably, I'm not sure).
* Packed full of 1.9 incompatibilities (I'm assuming).
* Packed full of space ninjas.
* Over 14% more awesome than a bag of chips.
