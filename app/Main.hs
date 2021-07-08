{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main
  ( main
  ) where

import qualified Bug.Experimental as Experimental
import qualified Bug.Legacy as Legacy
import Bug.User (User, migrateUsers)
import Control.Monad (void)
import Control.Monad.IO.Unlift (MonadUnliftIO)
import Control.Monad.Logger (MonadLogger, runStderrLoggingT)
import Control.Monad.Trans.Resource (MonadResource, runResourceT)
import Data.Text (Text)
import Data.Yaml.Config (loadYamlSettings, useEnv)
import Database.Persist
import Database.Persist.Postgresql
  (SqlReadT, createPostgresqlPoolWithConf, defaultPostgresConfHooks, runMigration, runSqlPool)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  case args of
    "legacy" : _ -> run Legacy.fetchUsersExcept
    "experimental" : _ -> run Experimental.fetchUsersExcept
    _ -> putStrLn "stack exec esqueleto-bug -- legacy|experimental"

run
  :: (  forall m
      . (MonadUnliftIO m, MonadLogger m, MonadResource m)
     => [Text]
     -> SqlReadT m [Entity User]
     )
  -> IO ()
run fetch = do
  pool <- createPool =<< loadYamlSettings ["env.yaml"] [] useEnv
  let runDB = runResourceT . runStderrLoggingT . flip runSqlPool pool
  runDB $ runMigration migrateUsers
  void $ runDB $ fetch ["joe"]
  void $ runDB $ fetch []
 where
  createPool =
    runStderrLoggingT
      . flip createPostgresqlPoolWithConf defaultPostgresConfHooks
