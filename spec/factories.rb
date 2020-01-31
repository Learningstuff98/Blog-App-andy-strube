FactoryBot.define do
  factory :blog do
    
  end

  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com" 
    end
    password { "secretPassword" }
    password_confirmation { "secretPassword" }
  end

  factory :subblog do
    name {'subblog name'}
    description {'this is the subblog description'}
    association :user
  end
end
