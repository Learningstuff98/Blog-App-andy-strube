FactoryBot.define do
  factory :photo do
    
  end

  factory :lock do
    is_locked {false}
    association :blog
  end

  factory :response do
    response_message {"response message"}
    association :user
    association :comment
  end

  factory :comment do
    message {"comment message"}
    association :user
    association :blog
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
