# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project do
    sequence(:name) { |seq| "Project-#{seq}" }

    user # association
  end
end
