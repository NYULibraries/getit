# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    firstname 'Dev'
    lastname 'Eloper'
    password_salt Authlogic::Random.hex_token
    crypted_password { Authlogic::CryptoProviders::Sha512.encrypt("#{username}#{password_salt}") }
    persistence_token Authlogic::Random.hex_token
    trait :aleph_attributes do
      user_attributes do
        {
          nyuidn: 'BOR_ID',
          verification: 'VERIFICATION',
          primary_institution: :NYU,
          institutions: [:NYU],
          bor_status: '51',
          aleph_permissions: {
            'BOBST' => {
              hold_permission: 'Y',
              hold_on_shelf: 'Y',
              photo_permission: 'Y'
            },
            'BAFC' => {
              hold_permission: 'N',
              hold_on_shelf: 'N',
              photo_permission: 'N'
            }
          }
        }
      end
    end
    factory :aleph_user, traits: [:aleph_attributes]
  end
end
