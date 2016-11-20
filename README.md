# Relical

## Asynchronous Caches for Swift 3

A collection of cache objects conforming to a unified `AsynchronousCache` protocol.

## Caches ##

- `InMemoryCache` wraps `NSCache` with an asynchronous API _(no performance advantages are to be expected)_
- `OnDiskCache` combines an in-memory `NSCache` with on-disk persistence, which should only be used by one process per cache

## Tests ##

*Relical* covered by unit tests and uses XCTest measure blocks to make the cache access times visible and comparable.

## License ##
#### The MIT License (MIT) ####
Copyright &copy; 2016 Marcel Dierkes

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
