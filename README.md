# tasks_sinatra_web_app
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
