# tasks_sinatra_web_app

## Overview

Sinatra Portfolio Project for Flatiron School

This project allows users to create and track tasks that are assigned to users.

Users are arranged into an organizational hierarchy in which users have a single
manager which they report to. Users are able to assign tasks to themselves and
all individuals below them in the organizational hierarchy. A user cannot assign
a task to their manager or anyone else above them in the organization.

Tasks belong to users in two ways - through ownership or through creation. The
task creator is the user who generated the task. The task owner is the user to
which the task is assigned.  The task creator and task owner may be the same
person if the user created and assigned themself the task.

Users can add notes to any task to which they have access.

## Installation

To install and run the app:
- Clone [this GitHub repository](https://github.com/Btate712/tasks_sinatra_web_app),
- Run `bundle install`
- Set a `SESSION_SECRET` environment variable by typing `export SESSION_SECRET="(your secret here)"`
  replacing "your secret here" with the desired secret value.  A randomly generated
  value is recommended.
- run the app using the command `rackup`.

## Contributing

When contributing to this repository, please first discuss the change you wish to make via issue,
email, or any other method with the owners of this repository before making a change.

## Pull Request Process

1. Ensure any install or build dependencies are removed before the end of the layer when doing a
   build.
2. Update the README.md with details of changes to the interface, this includes new environment
   variables, exposed ports, useful file locations and container parameters.
4. You may merge the Pull Request in once you have the sign-off of two other developers, or if you
   do not have permission to do that, you may request the second reviewer to merge it for you.

## Links
[Video Walkthrough](https://www.youtube.com/watch?v=qJCnNi-AaMU&t=17s)
[License](https://opensource.org/licenses/MIT)
