# RoseQuartz

[![Build Status](https://travis-ci.org/little-bobby-tables/rose_quartz.svg?branch=master)](https://travis-ci.org/little-bobby-tables/rose_quartz)
[![Test Coverage](https://codeclimate.com/github/little-bobby-tables/rose_quartz/badges/coverage.svg)](https://codeclimate.com/github/little-bobby-tables/rose_quartz/coverage)

A gem that adds two-factor authentication (time-based one-time passwords) to [Devise](https://github.com/plataformatec/devise) 
using the [rotp](https://github.com/mdp/rotp) library.

It attempts to stay lightweight by making a lot of assumptions — for example, that 
you have a single authenticatable resource, `User`, and that you're using `ActiveRecord`.

Highlights of *RoseQuartz* are:

* Zero tampering with the `User` model — no additional fields, no included modules.
* Separate table that can be updated in future without affecting your codebase and data.
* Built with Rails 5 and Devise 4 in mind.

The gem is still in development. All tests for core functionality are passing, but UI integration is not implemented yet.
