# Change Log

## 2017-02-10

- Setup rake task to clean out old users: `rake getit:cleanup:users`

## 2014-12-09
- __Configurable Search Methods__
    Search methods are in configula now so they can change per environment, e.g. reindex :crown:.
- __Poltergeist Cucumber Tests__
  After much trickery :wrench:, got the Cucumber tests running on Poltergeist and passing on Travis :tophat:.
- __Google Analytics__
  Upgraded nyulibraries-assets :gem: to use Google analytics helpers and added the GetIt tracking code.
- __Exlibris Environments__
  The environment-specific Exlibris urls (for either Aleph or Primo) are pulled from env vars now instead of separate gems.
- __EZBorrow__
  Options for EZBorrow where user has permissions.

## 2014-03-20
- __Exclude Shanghai Web Resources__  
  Don't display Shanghai web resources as "Copies in Library"

## 2014-03-06
- __Refresh Users Daily__  
  Refresh users every day in production to ensure we have the latest
  Aleph request permissions

## 2014-02-20
- __Upgrade Rails version for security__  
  Upgrade to Rails v3.2.17 to fix DOS security vulnerabilty

## 2014-01-16
- __Use the official Umlaut :gem:__  
  Use the official Umlaut :gem:, not our forked "bootstrap" branch,
  so future upgrades will be easy
- __Update Styles__  
  Since we're using the fancy new Umlaut :gem:, we updated our styles
  based on the fancy awesomeness that was available
- __Send/Share__  
  We created a separate section for "Send/Share" which makes it easy for
  user to see their "Send/Share" options
- __Update 866$l Mapping Table__  
  Update the 866$l mapping table to better match coverage information
  for Aleph holdings

## 2014-01-08
- __Update Umlaut :gem: to get a bug fix for institutional services__  
  Get latest from the Umlaut bootstrap branch to get the properly formatted
  URL for Umlaut's background updater
- __Improve Error Handling for Requesting__  
  When loading additional attributes, rescue any errors encountered so
  the user is not concerned with system issues, e.g. Aleph is down.

## 2013-12-19
- __Improve DB Performance for Users__  
  Add a unique username index to the users table to improve performance
- __Fix bug in Wayfinder service for institutions__  
  Upgrade the [authpds :gem:](/scotdalton/authpds) to fix [bug #6](/NYULibraries/getit/issues/6)

## 2013-12-04
- __Upgrade Rails version for security__  
  Upgrade to Rails v3.2.16 to fix i18n security vulnerabilty

## 2013-11-21
- __Upgrade the Exlibris NYU :gem:__  
  Upgrade the bundled [Exlibris NYU :gem:] to fix non-escaped ampersands coming Primo

## 2013-11-07
- __Gauges Web Analytics__  
  Added per institution web analytics

## 2013-10-25

### Functional Changes
- __Shibboleth Integration__  
  We've integrated the [PDS Shibboleth integration](https://github.com/NYULibraries/pds-custom/wiki/NYU-Shibboleth-Integration)
  into this release.

### Technical Changes
- :gem: __Updates__: Most gems are up to date. We're not on Rails 4, so that's the exception.

- __Update authpds-nyu__: Use the Shibboleth version of the
  [NYU PDS authentication gem](https://github.com/NYULibraries/authpds-nyu/tree/v1.1.2).
  Updated tests to reflect that change.

## 2013-10-08

### Functional Change
- __Enhance the Citation More Often with Primo Metadata__  
  When GetIt resolves a citation using either an ISSN or ISBN, it will enhance the citation
  with metadata from Primo.  Previously, we only enhanced the citation with Primo if we resolved
  the citation using the Primo record id.  This was begging to be more inclusive, so we made it
  more inclusive :open_hands:

### Technical Change
- __Update umlaut-primo :gem:__ Get the latest [Umlaut Primo gem](https://github.com/team-umlaut/umlaut-primo)
  in order to enhance referent when we have ISSN or ISBN
