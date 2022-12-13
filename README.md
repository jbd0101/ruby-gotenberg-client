# Gotenberg client for Ruby

[Gotenberg] is awesome, but using it with Ruby is complicated.

This gem is not intended to wrap the whole api of Gotenberg but to make
the creation of PDFs easy in Ruby / Ruby on Rails.

This gem is young and needs a lot of updates and improvements. (Work in progress, be patient, or contribute :-) )

## Install

First download and run Gotenberg:

```
docker run --rm -p 3000:3000 gotenberg/gotenberg:7
```

Install `gotenberg-client` gem

```
gem install gotenberg-client
```

or add `gotenberg-client` to your Gemfile.

## Usage

You will probably use this gem to generate PDFs in a Ruby on Rails background job or in a Ruby file.

Therefore, this gem does not (yet) integrate with any Ruby on Rails tools.

```ruby
require "gotenberg"

api_endpoint = "http://localhost:3000" # change it with your specific port and address.
gb = Gotenberg::Client.new(api_endpoint)

# check whether your endpoint is working
gb.up? # true if working

output_pdf = Tempfile.new("my-pdf.pdf")
html = "<h1> my html </h1>"
gb.html(html, output_pdf)

# Do not forget to destroy your tempfile
output_pdf.close
output_pdf.unlink
```

If you want to use Rails views, the easiest way is to use [`ActionController::Base#render_to_string`][render_to_string].

Say you have a view file `app/views/test.html.erb` that requires a `@customer` variable.

```ruby
gb = Gotenberg::Client.new(api_endpoint)

output_pdf = Tempfile.new("my-pdf.pdf")
ac = ActionController::Base.new
ac.instance_variable_set(:@customer, Customer.find(params[:id]))
gb.html(ac.render_to_string("/test.html.erb"), output_pdf)
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jbd0101/ruby-gotenberg-client.


## License

do whatever you want with it

[Gotenberg]: https://gotenberg.dev/
[render_to_string]: https://api.rubyonrails.org/classes/AbstractController/Rendering.html#method-i-render_to_string