version = 1

Meteor.startup ->
  Migrations = Migrations or []

  for migration in Migrations
    Migrations.add(migration)

Spire.migrate = ->
  version = Migrations._list.length - 1
  control = Migrations._collection.findOne("control")
  if not control # don't run migrations if they haven't run before (e.g. dev environment or new prod installation)
    Migrations._collection.insert({_id: "control", "locked": false, "version": version})
  else
    if control.version < version # for suppressing redundant log messages
      Migrations.migrateTo("latest")

