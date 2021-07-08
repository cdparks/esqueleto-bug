{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_GHC -fno-warn-deprecations #-}

module Bug.Legacy
  ( fetchUsersExcept
  ) where

import Bug.User
import Control.Monad.IO.Class (MonadIO)
import Data.Text (Text)
import Database.Esqueleto.Legacy

fetchUsersExcept :: MonadIO m => [Text] -> SqlReadT m [Entity User]
fetchUsersExcept names = select . from $ \users -> do
  where_ $ users ^. UserName `notIn` valList names
  pure users
