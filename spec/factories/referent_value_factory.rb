# ReferentValue factory
FactoryBot.define do
  factory :referent_value do
    key_name 'key'
    value 'Value'
    normalized_value { value.downcase }
    metadata true
    private_data false
    trait :format do
      key_name 'format'
      metadata false
    end
    trait :genre do
      key_name 'genre'
    end
    trait :genre do
      key_name 'genre'
    end
    trait :journal do
      value 'journal'
    end
    trait :book do
      value 'book'
    end
    factory :journal_format_value, traits: [:journal, :format]
    factory :book_format_value, traits: [:book, :format]
    factory :journal_genre_value, traits: [:journal, :genre]
    factory :book_genre_value, traits: [:book, :genre]
  end
  factory :title_value, parent: :referent_value do
    key_name 'title'
  end
  factory :author_value, parent: :referent_value do
    key_name 'au'
  end
  factory :isbn_value, parent: :referent_value do
    key_name 'isbn'
  end
  factory :issn_value, parent: :referent_value do
    key_name 'issn'
  end
end
