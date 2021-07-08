{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeApplications #-}

module Bug.Experimental
  ( fetchUsersExcept
  ) where

import Bug.User
import Control.Monad.IO.Class (MonadIO)
import Data.Text (Text)
import Database.Esqueleto.Experimental

fetchUsersExcept :: MonadIO m => [Text] -> SqlReadT m [Entity User]
fetchUsersExcept names = select $ do
  users <- from $ table @User
  where_ $ users ^. UserName `notIn` valList names
  pure users
