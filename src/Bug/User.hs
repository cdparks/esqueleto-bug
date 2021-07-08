{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE UndecidableInstances #-}

module Bug.User
  ( User
  , UserId
  , EntityField(..)
  , Key(UserKey)
  , migrateUsers
  ) where

import Data.Text (Text)
import Database.Persist
import Database.Persist.TH (mkMigrate, mkPersist, persistLowerCase, share, sqlSettings)

share [mkPersist sqlSettings, mkMigrate "migrateUsers"] [persistLowerCase|
User sql=users
  name Text
|]
