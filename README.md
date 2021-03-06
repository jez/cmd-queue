# ⌘ + Queue

> A simple queueing service for CMU students.

See it live at <https://cq.jez.io>. (You'll need a CMU login).

<a href="https://raw.githubusercontent.com/jez/cmd-queue/master/screenshots/list01.png"><img src="https://raw.githubusercontent.com/jez/cmd-queue/master/screenshots/list01.png" alt="⌘ + Queue" width="350"></a>

Say you're leading office hours for a class and the number of people waiting
starts to grow. Just create a queue, called say "15-122", and throw up a link to
https://cq.jez.io/15-122 on the board. This saves board space, eliminates the
need for arrows when the queue grows too long for one column, and comes with a
bunch of other features.

## Features

### Andrew account log ins

You don't have to create an account to log in; simply log in using your existing
Andrew username and password.

### It's mobile friendly

Having to open up your laptop just to check a checkbox is crazy. ⌘ + Queue was
designed mobile first, so everything works on mobile just like you'd expect it
to.

### Real-time updates

You don't even have to refresh the page to see the current state of the queue.

Students are always busy, so sometimes it's hard to know you'll be productive by
going to office hours. With ⌘ + Queue, students can check anywhere what the
approximate wait time will be.

### Private Queues

Don't like that it updates in real time with a list of all the students who are
at office hours? Queue owners can make their queues private.

### Multiple owners

Invite your fellow TA's to the queue so you all can cross people off.

### That doesn't seem like a lot of features

You're right. Simplicity is key; there's no clutter and no cruft.

That being said, if you think it's missing a feature, feel free to implement it
and open a pull request!


## Why build this?

I put this together mostly just to have something to tinker on and try out a few
new technologies. Here's a quick run down of the pieces involved:

- __Node.js__ with CoffeeScript everywhere
- __Passport.js__ for authentication with your Andrew account
- __Sequelize__ and __PostgreSQL__ for storage
- __Socket.io__ for real-time updates
- __React__ for client-side templating
- __React Router__ for client-side routing
- __Mailgun__ for sending transactional emails (I get exception notification emails)

The thing about a queue service is that it's just a step up from a Todo app, so
it's got just the right amount of complexity to let you see where certain
technologies shine or don't.

## Setup

You can run this using Heroku (or more generally, `foreman`). It uses the same
build tooling as [TuneMachine][tm], so I'm not going to duplicate the setup
instructions. The only thing that's different will be setting all the config
variables. Copy `.env.template` to `.env` and fill in the corresponding values.

## License

MIT license. See LICENSE.

[tm]: https://github.com/jez/tunemachine
