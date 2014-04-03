# Referent factory
FactoryGirl.define do
  factory :referent do
    title 'title'
    issn '1234-6789'
    isbn '1234567890123'
    year '2014'
    volume '1'
    ignore do
      format 'book'
      author 'author'
    end
    after(:create) do |referent, evaluator|
      create("#{evaluator.format}_format_value", referent: referent)
      create("#{evaluator.format}_genre_value", referent: referent)
      [:title, :author, :issn, :isbn, :year, :volume].each do |attribute|
        next if [:issn, :year, :volume].include?(attribute) && evaluator.format == 'book'
        next [:isbn].include?(attribute) && evaluator.format == 'journal'
        create("#{attribute}_value", evaluator.send(attribute), referent: referent)
      end
    end
  end
end
