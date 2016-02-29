# hanami-fumikiri
Hanami User Authentication.  

As most will know by now, Hanami Framework is turning out to be a very well thought one.
I have found that it is best suited for API apps and as it goes, there is no single best practice or gem that the Hanami community is pouring into for the all important Authentication side of things. This gem is a trial at answering this question.

This is to help newcomers get up and running as quick and from experience it has been this part that is holding back a lot of developers. The need to get a quick concept/project out there or to have a backend for a mobile app is growing. Speed to launch counts and a community effort on authentication and authorization should kinda come along with the framework.

Fumikiri means a gate across a railway crossing.

## Concepts
This approach is inclined towards seperating the Hanami Stack from the front-end. While Hanami has a very good asset and front-end support. We recommend seperating the two completely. Therefore, Fumikiri is totally implemented for JSON Web Tokens.

## Features
Light and completely follows the JWT official Specifications.
Support for
- Web or browser based Authentication
- API or mobile app style Authentication
- CLI style  Authentication
