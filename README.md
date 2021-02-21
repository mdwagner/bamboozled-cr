# Introduction

Bamboozled-cr is a Crystal port of the Ruby wrapper [Bamboozled](https://github.com/Skookum/bamboozled).

Both are an HTTP Client library for the [BambooHR API](https://documentation.bamboohr.com/docs).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     bamboozled-cr:
       github: mdwagner/bamboozled-cr
   ```

2. Run `shards install`

## Usage

```crystal
require "bamboozled-cr"
```

Please checkout the `spec/bamboozled/api` directory for examples.

## Contributing

1. Fork it (<https://github.com/mdwagner/bamboozled-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Michael Wagner](https://github.com/mdwagner) - creator and maintainer
