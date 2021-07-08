# esqueleto-bug

**tl;dr** PostgreSQL 10.14 rejects queries produced by
`esqueleto-3.5.0.0` when `notIn` is passed an empty list

Until recently, both `in_` and `notIn` used a helper function
`ifNotEmptyList` to avoid generating expressions like `x in ()` and
`x not in ()`. Now only `in_` appears to do so, which means that
invocations of `notIn` can fail at runtime when using the Postgres
backend. MySQL appears to allow this syntax.

## Setup

`esqueleto-bug` uses a database `esqueleto_bug` owned by the `postgres`
user, e.g.:

```sql
CREATE DATABASE esqueleto_bug OWNER postgres ENCODING 'UTF8';
```

See `env.yaml` for the other Postgres environment variables.

## Running

Generate a malformed SQL query using `Database.Esqueleto.Legacy`:

```console
$ stack run esqueleto-bug -- legacy
[Debug#SQL] SELECT "users"."id", "users"."name"
FROM "users"
WHERE "users"."name" NOT IN (?)
; [PersistText "joe"]
[Debug#SQL] SELECT "users"."id", "users"."name"
FROM "users"
WHERE "users"."name" NOT IN ()
; []
esqueleto-bug: SqlError {sqlState = "42601", sqlExecStatus = FatalError, sqlErrorMsg = "syntax error at or near \")\"", sqlErrorDetail = "", sqlErrorHint = ""}
```

Generate a malformed SQL query using `Database.Esqueleto.Experimental`:

```console
$ stack run esqueleto-bug -- experimental
[Debug#SQL] SELECT "users"."id", "users"."name"
FROM "users"
WHERE "users"."name" NOT IN (?)
; [PersistText "joe"]
[Debug#SQL] SELECT "users"."id", "users"."name"
FROM "users"
WHERE "users"."name" NOT IN ()
; []
esqueleto-bug: SqlError {sqlState = "42601", sqlExecStatus = FatalError, sqlErrorMsg = "syntax error at or near \")\"", sqlErrorDetail = "", sqlErrorHint = ""}
```
