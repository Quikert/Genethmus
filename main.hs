import Processing (readClients)
import Status (saveResults, countResults)
import System.Environment (getArgs)
import System.Directory (removeFile)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [file] -> do
      clients <- readClients file
      saveResults clients
      countResults clients
      removeFile file
      putStrLn ("Processing finished. Results saved in approved.json, rejected.json, pending.json. " ++ file ++ " deleted.")
    _ -> putStrLn "Usage: ./finance <file.csv>"
