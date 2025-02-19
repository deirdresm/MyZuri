#  A Migration Guide

(Note: I write these for all SwiftData projects, but don't usually commit them, but realized it might help someone. Every phrase is something I've missed at some point or another. So.)

1. In the file named `MyZuriMigrationPlan.swift`, add a new `VersionedSchema` at the bottom of the file.
2. Ensure this file has *all* the tables you'll use in that migration, with names correctly spelled and version correctly updated from the previous one.
3. Copy your old models into an archive file, and renumber your model files. Edit as needed.
4. Write the new `MigrationStage` and check everything. You're going *from* the correct version *to* the correct version, and any `FetchDescription` has the correct versioning.
5. 

## Model Changes Over Time

### V2P3 (2.3)

* Add `createdAt` (date created) for `ProductColor` to help with item ordering.
* Delete `ColorProminence` enum (which had been unused since `ProductColor` took over from `ItemColor`). (But make sure it's in prior iterations of the model!)
* Add `WishlislistStatus` so we can sort on wishlist items keep the freshest up top.
* Add `url` field, optional (since most will not use this), to `Item`.
