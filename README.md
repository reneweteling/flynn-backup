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
6. open up your brower to your flynn url and login with `admin@example.com` / `password` (you can change this when your logged in)

## Buildpacks
1. https://github.com/heroku/heroku-buildpack-ruby.git, lets let rails do its thing
2. https://github.com/reneweteling/flynncli-buildpack.git, install the flynn cli in the container

## Env variables

| ENV_VAR               | DESCRIPTION                                              |
|-----------------------|----------------------------------------------------------|
| PGHOST                | DB credentials, provided by Flynn                        |
| PGUSER                | DB credentials, provided by Flynn                        |
| PGPASSWORD            | DB credentials, provided by Flynn                        |
| PGDATABASE            | DB credentials, provided by Flynn                        |
| AWS_ACCESS_KEY_ID     | Aws credentials for off-site backup storage              |
| AWS_SECRET_ACCESS_KEY | Aws credentials for off-site backup storage              |
| AWS_REGION            | Aws credentials for off-site backup storage              |
| AWS_BUCKET            | Aws credentials for off-site backup storage              |
| FLYNN_KEY             | Flynn cluster credentials, see ~/.flynnrc for the values |
| FLYNN_TLSPIN          | Flynn cluster credentials, see ~/.flynnrc for the values |
| FLYNN_DOMAIN          | Flynn cluster credentials, see ~/.flynnrc for the values |

## Roadmap
1. [x] Get it to work
2. [ ] Replace the backup to tmp file to aws with backup stdout to stdin from the awscli, eliminatig the need for a big tmp disk
3. [ ] add LetsEncrypt to the mix to automaticly renew and set your ssl sertificates

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



flynn -a router env set ADDITIONAL_HTTP_PORTS=3000,8080

flynn -a flynn-backup route add http -p 8080 backup.weteling.com

alias hostingtunnel="ssh -f -N -L 8080:localhost:8080 root@hosting.weteling.com && open 'http://dashboard.weteling.com:8080' && open 'http://backup.weteling.com:8080'"