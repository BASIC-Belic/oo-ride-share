require_relative 'spec_helper'
require 'pry'

USER_TEST_FILE   = 'specs/test_data/users_test.csv'
TRIP_TEST_FILE   = 'specs/test_data/trips_test.csv'
DRIVER_TEST_FILE = 'specs/test_data/drivers_test.csv'

describe "Driver class" do

  describe "Driver instantiation" do

    before do

      @driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ",
        phone: '111-111-1111',
        status: :AVAILABLE
      )
    end

    it "is an instance of Driver" do
      expect(@driver).must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad status" do
      expect{ RideShare::Driver.new(id: 15, name: "George", vin: "33133313331333133", status: :in_an_open_relationship)}.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      expect{

        RideShare::Driver.new(id: 100, name: "George",
        vin: "", status: :AVAILABLE)
      }.must_raise ArgumentError
      expect{ RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums", status: :AVAILABLE)}.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@driver.driven_trips).must_be_kind_of Array
      expect(@driver.driven_trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vehicle_id, :status, :driven_trips].each do |prop|
        expect(@driver).must_respond_to prop
      end

      expect(@driver.id).must_be_kind_of Integer
      expect(@driver.name).must_be_kind_of String
      expect(@driver.vehicle_id).must_be_kind_of String
      expect(@driver.status).must_be_kind_of Symbol
    end
  end

  describe "add_driven_trip method" do

    before do
      pass = RideShare::User.new(id: 1, name: "Ada", phone: "412-432-7640")
      @driver = RideShare::Driver.new(id: 3, name: "Lovelace", vin: "12345678912345678", status: :AVAILABLE)

      @trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: pass, date: "2016-08-08", rating: 5, start_time: 30, end_time: 60)
    end

    it "throws an argument error if trip is not provided" do

      expect{ @driver.add_driven_trip(1) }.must_raise ArgumentError
    end

    it "increases the trip count by one" do
      previous = @driver.driven_trips.length

      @driver.add_driven_trip(@trip)
      expect(@driver.driven_trips.length).must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do

      start_time = '2015-05-20T12:14:00+00:00'
      end_time = '2015-05-20T12:15:00+00:00'#
      @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)


        trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334"), start_time: start_time, end_time: end_time, cost: 10, rating: 5)

        @driver.add_driven_trip(trip)
      end

        it "returns a float" do
          expect(@driver.average_rating).must_be_kind_of Float
        end

        it "returns a float within range of 1.0 to 5.0" do
          average = @driver.average_rating
          expect(average).must_be :>=, 1.0
          expect(average).must_be :<=, 5.0
        end

        it "returns zero if no trips" do
          driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV",
            vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)
            expect(driver.average_rating).must_equal 0
          end

          it "correctly calculates the average rating" do

            start_time = '2015-05-20T12:14:00+00:00'
            end_time = '2015-05-20T12:15:00+00:00'

            trip2 = RideShare::Trip.new(id: 9, driver: @driver, passenger: RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334"), start_time: start_time, end_time: end_time, cost: 10, rating: 1)
              @driver.add_driven_trip(trip2)

              expect(@driver.average_rating).must_be_close_to (5.0 + 1.0) / 2.0, 0.01
            end
          end

          describe "total_revenue" do
            it 'will calculate revenue' do

            start_time = '2015-05-20T12:14:00+00:00'
            end_time = '2015-05-20T12:15:00+00:00'#
            @driver = RideShare::Driver.new(id: 54, name: "Rogers Bartell IV", vin: "1C9EVBRM0YBC564DZ", status: :AVAILABLE)


              trip = RideShare::Trip.new(id: 8, driver: @driver, passenger: RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334"), start_time: start_time, end_time: end_time, cost: 30, rating: 5)

              @driver.add_driven_trip(trip)

              trip2 = RideShare::Trip.new(id: 9, driver: @driver, passenger: RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334"), start_time: start_time, end_time: end_time, cost: 10, rating: 1)


                @driver.add_driven_trip(trip2)

                expect(@driver.total_revenue).must_be_close_to 29.36
              end
          end

          describe "net_expenditures" do

        it 'will do something ' do
              @dispatcher = RideShare::TripDispatcher.new(USER_TEST_FILE,TRIP_TEST_FILE,DRIVER_TEST_FILE)
              start_time = '2015-05-20T12:14:00+00:00'
              end_time = '2015-05-20T12:15:00+00:00'

              driver = @dispatcher.drivers[0]

              trip = RideShare::Trip.new(id: 8, driver: driver, passenger: RideShare::User.new(id: 1, name: "Smithy", phone: "353-533-5334"), start_time: start_time, end_time: end_time, cost: 40, rating: 5)

              driver.add_driven_trip(trip)

              # @dispatcher.drivers[0].trips[0].cost => 10.0
              #@dispatcher.drivers[0].trips[1].cost => 7.0
              # @dispatcher.drivers[0].driven_trips[0].cost => 40
              expect(driver.net_expenditures).must_be_close_to 13.68
            end
          end
        end
