module Status (saveResults, countResults) where

import Processing (Client(..), decisionCategory, decisionReason, Category(..))

-- convert client result to JSON string
clientToJson :: Client -> String
clientToJson c =
  "{ \"name\": \"" ++ firstName c ++ " " ++ lastName c ++
  "\", \"age\": " ++ show (age c) ++
  ", \"city\": \"" ++ city c ++ "\"" ++
  ", \"job\": \"" ++ job c ++ "\"" ++
  ", \"marital\": \"" ++ marital c ++ "\"" ++
  ", \"children\": " ++ show (children c) ++
  ", \"balance\": " ++ show (balance c) ++
  ", \"income\": " ++ show (income c) ++
  ", \"category\": \"" ++ show (decisionCategory c) ++ "\"" ++
  ", \"reason\": \"" ++ decisionReason c ++ "\" }"

saveResults :: [Client] -> IO ()
saveResults clients = do
  let approved = filter (\c -> decisionCategory c == Approved) clients
  let rejected = filter (\c -> decisionCategory c == Rejected) clients
  let pending  = filter (\c -> decisionCategory c == Pending) clients
  writeFile "approved.json" ("[\n" ++ unlines (map clientToJson approved) ++ "]")
  writeFile "rejected.json" ("[\n" ++ unlines (map clientToJson rejected) ++ "]")
  writeFile "pending.json"  ("[\n" ++ unlines (map clientToJson pending) ++ "]")

countResults :: [Client] -> IO ()
countResults clients = do
  let approved = length (filter (\c -> decisionCategory c == Approved) clients)
  let rejected = length (filter (\c -> decisionCategory c == Rejected) clients)
  let pending  = length (filter (\c -> decisionCategory c == Pending) clients)
  putStrLn ("Approved: " ++ show approved)
  putStrLn ("Rejected: " ++ show rejected)
  putStrLn ("Pending: "  ++ show pending)
