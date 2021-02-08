# T & C Generator

Generates a document from the input template and dataset

## Dependencies

* [Ruby](https://www.ruby-lang.org/en/).  Written with version [2.5.0](https://www.ruby-lang.org/en/news/2017/12/25/ruby-2-5-0-released/) - *[docs](https://docs.ruby-lang.org/en/2.5.0/)*.

## Usage

Install deps: `gem install bundler && bundle install`.

Run `rspec test/lib/template_spec.rb` to run the tests.

Run `ruby lib/template.rb` to run the program.

## Important Notes

Took around 4 hours to finish this challenge

Pending Items: 
 - Handle the case where dataset is not sufficient to generate the document from a given template.
 - Handling of a large file.
 - Error handling.
