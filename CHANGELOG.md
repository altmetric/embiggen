# Change Log

All notable changes to this project will be documented in this file. This
project adheres to [Semantic Versioning](http://semver.org/).

## [1.10.0] - 2026-04-27

### Added

- Support for non-redirect shorteners (e.g. `lnkd.in`, `ebx.sh`) that serve
  an HTML page instead of issuing an HTTP redirect; the destination URL is
  extracted via a configurable CSS selector

### Fixed

- `require 'set'` was missing from `ShortenerList`, causing a `NameError` on
  Ruby 3.2+ where `Set` is no longer auto-loaded
- Domain strings were not escaped before being interpolated into regexes in
  `ShortenerList` and `NonRedirectShortenerList`, so a dot in a domain name
  (e.g. `bit.ly`) would match any character rather than a literal dot
- `ShortenerList#+` re-processed already-compiled `Regexp` patterns through
  `host_pattern`, double-wrapping them and raising a `TypeError` once
  `Regexp.escape` was introduced

## [1.9.0] - 2026-04-23

### Changed

- Added 1 new shortener (`kidney.pub`)

## [1.8.0] - 2025-05-07

### Changed

- Added 1 new shortener (`go.skimresources.com`)

## [1.7.0] - 2025-01-01

### Changed

- Added 1 new shortener (`go.bsky.app`)

## [1.6.0] - 2024-11-20

### Changed

- Added 949 new shorteners
- Added 241 new Bitly branded domain shorteners
- Removed 1 duplicate `mz.cm,`

## UNRELEASED - 2024-10-15

### Changed

- Modernise dev dependencies
- Replace Travis CI with GitHub Actions (remove Hound configuration)
- Add house_style and apply the corrections
- Change the supporting Ruby versions to 2.7 onwards

## [1.5.0] - 2018-01-23

### Changed

- Added 150 new Bitly Pro domain shorteners

## [1.4.0] - 2017-11-16

### Changed

- Added 10 new shorteners (including World Bank's)

## [1.3.0] - 2017-07-25

### Changed

- Added 1,356 new shorteners (including Amazon's)
- Switched to using a GET request to follow shortened links to improve
  compatibility with services that reject HEAD requests (e.g. Amazon)

## [1.2.5] - 2017-03-10

### Changed

- Added another 531 shorteners

## [1.2.4] - 2017-01-16

### Changed

- Add another 561 domains from vanityurlshorteners.com
- Add six specific shorteners from Nature, Pocket, Ow.ly and others
- Correct the v1.2.3 changelog date

## [1.2.3] - 2017-01-04

### Changed

- Add another 337 Bitly Pro domains.
- Add Readcube's shortener.

## [1.2.2] - 2016-11-28

### Changed

- Add another 1,505 Bitly Pro domains.

## [1.2.1] - 2016-08-02

### Changed

- Add another 2,320 Bitly Pro domains.

## [1.2.0] - 2016-05-10

### Changed

- List of shorteners: it now includes 1,293 Bitly pro domains.

## [1.1.0] - 2016-01-15

### Changed

- Extract list of shorteners to a separate text file from @AvnerCohen;
- Speed up matching shorteners by generating regexps once on load from
  @AvnerCohen;
- Remove a dead shortener and add some new default ones from @AvnerCohen.

## [1.0.0] - 2015-11-21

### Added

- First stable version of Embiggen and its API for expanding shortened links.

[1.10.0]: https://github.com/altmetric/embiggen/releases/tag/v1.10.0
[1.9.0]: https://github.com/altmetric/embiggen/releases/tag/v1.9.0
[1.8.0]: https://github.com/altmetric/embiggen/releases/tag/v1.8.0
[1.7.0]: https://github.com/altmetric/embiggen/releases/tag/v1.7.0
[1.6.0]: https://github.com/altmetric/embiggen/releases/tag/v1.6.0
[1.5.0]: https://github.com/altmetric/embiggen/releases/tag/v1.5.0
[1.4.0]: https://github.com/altmetric/embiggen/releases/tag/v1.4.0
[1.3.0]: https://github.com/altmetric/embiggen/releases/tag/v1.3.0
[1.2.5]: https://github.com/altmetric/embiggen/releases/tag/v1.2.5
[1.2.4]: https://github.com/altmetric/embiggen/releases/tag/v1.2.4
[1.2.3]: https://github.com/altmetric/embiggen/releases/tag/v1.2.3
[1.2.2]: https://github.com/altmetric/embiggen/releases/tag/v1.2.2
[1.2.1]: https://github.com/altmetric/embiggen/releases/tag/v1.2.1
[1.2.0]: https://github.com/altmetric/embiggen/releases/tag/v1.2.0
[1.1.0]: https://github.com/altmetric/embiggen/releases/tag/v1.1.0
[1.0.0]: https://github.com/altmetric/embiggen/releases/tag/v1.0.0
