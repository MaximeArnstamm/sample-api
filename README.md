[![Build Status](https://travis-ci.org/MaximeArnstamm/sample-api.svg?branch=master)](https://travis-ci.org/MaximeArnstamm/sample-api)

! work in progress !

# Simplest sample rails API
I wanted to code a mobile back end API and i chose RoR over Node because i thought that all the plumbing was out of the box. I was wrong.

I'm still amazed that i had to do all this manual work for something like security and tests.

My main concern was that i wanted something really simple to use and to read. Authentication and testing were my main pain points.

So after a lot of time trying wrong gems and backing myself into corners of weird stacks, i finally have an API stack in Rails that is simple-ish.

### Authentication
I used devise, simple_token_authentication and some manual steps that i shouldn't have to do.

### Tests
Rspec + database_cleaner + airborne's helpers + some handwritten helpers.

### Documentation
Apipie documentation takes more place than the real code.
