FactoryBot.define do
  factory :comment do
    
  end

  factory :blog do
    title {'blog title'}
    content {'this is the blog content'}
    association :user
    association :subblog
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
