# WiserSms

Medium Rare Outgoing SMS

## Requirements

_WiserSms_ only support Rails >= 3.x.

## Networks

`WiserSms::Ph` only supports Globe Telecom, Smart Communications, and Sun Cellular networks.

_..more to come.._

## Setup

You can do normal gem installation in terminal:

```ruby
    $ gem install wiser_sms
```

or include it in your Gemfile:

```ruby
    gem 'wiser_sms', '~> 0.1.0'
```

Then restart your application.

## Usage

### Request to send SMS

To send SMS for single receiver, pass the string 11-digit string mobile mobile number and message using the `send` method:

```ruby
   WiserSms::Ph.send("091711292013", "You really did it!")
```

To send SMS for multiple receivers, pass the array of 11-digit string mobile number instead:

```ruby
  WiserSms::Ph.send(["091711292013","091711302013"], "You guys really did it!")
```

_Note: If you send the receiver's mobile number more than once, the message will still be sent once._

### Response

All responses will come in hash with the status for each mobile number passed to the `send` method.

Here's an example:

```ruby
  {"091711292013" => true, "091711302013" => true, "123" => nil}
````

#### Statuses

Response | Which Means
--- | ---
(BOOL) true | Message Sent
(BOOL) false | Sending Failed
(NULL) nil | Invalid Mobile Number


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Support
Open an issue in https://github.com/kennethjohnbalgos/wiser_sms if you need further support or want to report a bug.

## License

The MIT License (MIT) Copyright (c)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
