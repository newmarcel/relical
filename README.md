# Relical

## Asynchronous Caches for Swift 3

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/64e20e7840c34630a3e2ce3ea21362df)](https://www.codacy.com/app/newmarcel/relical?utm_source=github.com&utm_medium=referral&utm_content=newmarcel/relical&utm_campaign=badger)
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-ED523F.svg?style=flat)](https://github.com/apple/swift) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/newmarcel/relical.svg?branch=master)](https://travis-ci.org/newmarcel/relical)

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
