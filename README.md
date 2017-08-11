# Flynn backup app

So flynn.io is awesome, only some basic automatisation tasks are missing. At least for me. 

1. Automated backups to s3
2. Ssl with automated renewal (wip)

What this app does is just that, it uses a webinterface to manage our backup periods and apps. And it uses the flynncli to get all of the data from your cluster.

## Getting started
1. clone repo and create flynn app `flynn create flynn-backup`
2. push to your cluster `git push flynn master`
3. add postgress `flynn resource add postgres`
4. add missing env variables (the PG variables are already fixed by Flynn)
5. migrate your db `flynn run bin/rails db:migrate db:seed`
6. open up your brower to your flynn url and login with `admin` / `password` (you can change this when your logged in)

## Buildpacks
1. https://github.com/heroku/heroku-buildpack-ruby.git, lets let rails do its thing
2. https://github.com/reneweteling/flynncli-buildpack.git, install the flynn cli in the container

## Env variables
PGHOST=
PGUSER=
PGPASSWORD=
PGDATABASE=

## Roadmap
1. [ ] Get it to work
2. [ ] add LetsEncrypt to the mix to automaticly renew and set your ssl sertificates

## Contributing

* Fork the repo.
* Make sure the tests pass:
* Make your change, with new passing tests. 
* Push to your fork. Write a [good commit message][commit]. 
* Submit a pull request.

  [commit]: http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html

Others will give constructive feedback.
This is a time for discussion and improvements,
and making the necessary changes will be required before we can
merge the contribution.

## License

Flynn-backup is Copyright (c) 2017 Weteling Support.
It is free software, and may be redistributed
under the terms specified in the [LICENSE] file.

  [LICENSE]: /LICENSE

## About

Flynn-backup is maintained by René Weteling.

![René Weteling](http://www.weteling.com/zzz/footer.png)

Flynn-backup is maintained and funded by Weteling Support.

I love open source software!
See [my other projects][blog]
or [hire me][hire] to help build your product.

  [blog]: http://www.weteling.com/
  [hire]: http://www.weteling.com/contact/