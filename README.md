# hanami-fumikiri

[![Join the chat at https://gitter.im/theCrab/hanami-fumikiri](https://badges.gitter.im/theCrab/hanami-fumikiri.svg)](https://gitter.im/theCrab/hanami-fumikiri?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Hanami User Authentication.  

**[PLEASE CHECK THIS GIST FIRST](https://gist.github.com/theCrab/54a339b7a08ddad84e35)**

As most will know by now, Hanami Framework is turning out to be a very well thought one.
I have found that it is best suited for API apps and as it goes, there is no single best practice or gem that the Hanami community is pouring into for the all important Authentication side of things. This gem is a trial at answering this question.

This is to help newcomers get up and running as quick and from experience it has been this part that is holding back a lot of developers. The need to get a quick concept/project out there or to have a backend for a mobile app is growing. Speed to launch counts and a community effort on authentication and authorization should kinda come along with the framework.

Fumikiri means a gate across a railway crossing.

## Concepts
This approach is inclined towards separating the Hanami Stack from the front-end. While Hanami has a very good asset and front-end support. We recommend separating the two completely. Therefore, Fumikiri is totally implemented for JSON Web Tokens.

## User Authentication
Light and completely follows the JWT official Specifications.
Support for
- Allow username and password-based authentication - [Default] username and password based accounts are always enabled.

## User Sessions
- Require revocable sessions
- Expire inactive sessions
- Revoke session on password change

## Support for reserved claim names

JSON Web Token defines some reserved claim names and defines how they should be used. JWT supports these reserved claim names:

- 'exp' (Expiration Time) Claim. Error (`JWT::ExpiredSignature`)
- 'nbf' (Not Before Time) Claim. Error (`JWT::ImmatureSignature`)
- 'iss' (Issuer) Claim. Error (`JWT::InvalidIssuerError`)
- 'aud' (Audience) Claim. Error (`JWT::InvalidAudError`)
- 'jti' (JWT ID) Claim. Error (`JWT::InvalidJtiError`)
- 'iat' (Issued At) Claim. Error (`JWT::InvalidIatError`)
- 'sub' (Subject) Claim. Error (`JWT::InvalidSubError`)
