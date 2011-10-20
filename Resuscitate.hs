module Main where

import qualified Data.Set as DS
import System.Environment
import System.Exit
import System.Cmd (rawSystem)

main :: IO ()
main = do
    args <- getArgs
    case args of
        []     -> fail "No command to resusciate?"
        (x:xs) -> do
        trys <- (fmap read $ getEnv "RESUSCITATE_TRIES") `catch`
            (\_ -> return (-1))
        resuscitate trys (ExitSuccess) x xs

resuscitate :: Integer -> ExitCode -> String -> [String] -> IO ()
resuscitate 0 x _ _ = exitWith x
resuscitate n _ c a = do
    x <- rawSystem c a
    s <- (fmap (DS.fromList . (map read) . words) $
        getEnv "RESUSCITATE_EXCUSE") `catch` (\_ -> return DS.empty)
    case x of
        ExitSuccess   -> exitWith x
        ExitFailure y -> if DS.member y s then exitWith x else
            resuscitate (n - 1) x c a
