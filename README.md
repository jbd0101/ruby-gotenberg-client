# Gotenberg client for Ruby
Gotenberg is awesome, but using it with Ruby is complicated.
This gem is not intended to wrap the whole api of gotenberg but to make
the creation of pdf easy in ruby / ruby on rails.

this gem is young and needs a lot of updates and improvements. (work in progress, be patient, or contribute :-) )

## install
First download and run gotenberg

  $ docker run --rm -p 3000:3000 gotenberg/gotenberg:7


install gotenberg-client gem

  $ gem install gotenberg-client

or add gotenberg-client to your gemfile

## usage
you will probably use this gem in order to generate pdf in a ruby on rails background task / ruby file. Therefore, this gem do not (yet) integrate any Ruby on Rails tools.

```ruby
require "gotenberg"

api_endpoint = "http://localhost:3000" # change it with your specific port and address.
gb = Gotenberg::Client.new(api_endpoint)

#check whether your endpoint is working
gb.up? #true if working

output_pdf = Tempfile.new("my-pdf.pdf")
html = "<h1> my html </h1>"
gb.html(html,output_pdf)

#do not forget to destroy your tempfile
output_pdf.close
output_pdf.unlink

```

if you want to use rails views, the easiest way is to user "render_to_string" from `ActionController::Base`.
Let's imagine that you have a /app/views/test.html.erb in your project that use @customer variable.

```ruby
gb = Gotenberg::Client.new(api_endpoint)

output_pdf = Tempfile.new("my-pdf.pdf")
ac = ActionController::Base.new()
ac.instance_variable_set(:@customer,Customer.find(params[:id]))
gb.html(ac.render_to_string("/test.html.erb"),output_pdf)

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jbd0101/ruby-gotenberg-client.


## License

do whatever you want with it

