# GetIt @ NYU

[![CircleCI](https://circleci.com/gh/NYULibraries/getit.svg?style=svg)](https://circleci.com/gh/NYULibraries/getit)
[![Maintainability](https://api.codeclimate.com/v1/badges/08eaeef7455153839f6e/maintainability)](https://codeclimate.com/github/NYULibraries/getit/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/NYULibraries/getit/badge.svg?branch=master)](https://coveralls.io/github/NYULibraries/getit?branch=master)

The GetIt application at NYU leverages [`Umlaut`](http://github.com/team-umlaut/umlaut) to provide just in time OpenURL resolution.
This means that GetIt should only display services that will result in useful delivery options based on the context of the current request.
Umlaut aggregates services for the requested citation represented by an Open URL and presents those options in clear categories based on
the nature of the service.
For more info check out the [GetIt wiki](http://github.com/NYULibraries/getit/wiki/Home) and/or
[Umlaut](http://github.com/team-umlaut/umlaut#umlaut).

## NYU Customizations
At NYU we've implemented a few features in GetIt @ NYU that aren't in your basic Umlaut application.

1.  Primo Integration: we use the [`Umlaut Primo`](https://github.com/team-umlaut/umlaut-primo) gem to add Primo support
2.  Aleph Integration: we've included some Aleph functionality, most notably the ability to request Aleph items
3.  SFX Solr Indexing: we've indexed SFX titles in Solr for quick retrieval using [`Sunspot`](http://sunspot.github.com/) and Umlaut's
    [`Sfx4Solr`](https://github.com/team-umlaut/umlaut/tree/master/app/controllers/search_methods/sfx4_solr)
4.  User Login: we've included the ability for users to login via SSO, using [`omniauth-nyulibraries`](http://github.com/nyulibraries/omniauth-nyulibraries).
5.  UI: we've customized the search UI to leverage
    [NYU Libraries' common layouts and assets](https://github.com/NYULibraries/nyulibraries-assets)
6.  Institutional support: we've included support for different institutions for both [searching](config/initializers/search_controller.rb)
    and [resolving](app/controllers/umlaut_controller.rb#L157)

## Enabled Services
Check out our wiki [page on services](http://github.com/NYULibraries/getit/wiki/Services).

## Developing

```
docker-compose up -d
```

### Run tests

```
docker-compose exec test rake
```

### Run server

```
docker-compose exec app rails server -b 0.0.0.0
```
