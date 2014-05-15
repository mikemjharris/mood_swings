FactoryGirl.define do
  factory :user do |f|
    fake_name = Faker::Name.name
    name fake_name
    email { Faker::Internet.email(fake_name) }
    password 'password'
    password_confirmation 'password'

    factory :user_with_answer_sets do
      after(:create) do |user, evaluator|
        create(:answer_set_with_answers, user: user, cohort: user.cohort || FactoryGirl.create(:cohort))
      end
    end

    factory :admin_user do
      role 'admin'
    end

    factory :cohort_admin_user do
      after(:create) do |user, evaluator|
        create(:cohort_administrator, administrator: user, cohort: create(:cohort))
      end
    end

    factory :campus_admin_user do
      after(:create) do |user, evaluator|
        create(:campus_administrator, administrator: user, campus: create(:campus))
      end
    end

  end
end