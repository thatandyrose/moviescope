# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show_time do
    cinema_id 1
    movie_id 1
    showing_at "2013-12-20 13:34:13"
  end
end
