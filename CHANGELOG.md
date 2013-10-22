# Change Log

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