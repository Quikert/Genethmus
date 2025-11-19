module Processing (
    Client(..),
    Category(..),   -- exports the type and its manufacturers
    readClients,
    decisionCategory,
    decisionReason
) where


data Category = Approved | Rejected | Pending deriving (Show, Eq)

data Client = Client
  { firstName   :: String
  , lastName    :: String
  , balance     :: Double
  , income      :: Double
  , incomeType  :: String
  , isMother    :: Bool
  , isFather    :: Bool
  , isInDebt    :: Bool
  , livesAlone  :: Bool
  , age         :: Int
  , job         :: String
  , marital     :: String
  , children    :: Int
  , city        :: String
  } deriving (Show)

-- yes/no -> Bool
toBool :: String -> Bool
toBool s = map toLower s == "yes"
  where toLower c = if c >= 'A' && c <= 'Z'
                       then toEnum (fromEnum c + 32)
                       else c

-- split by comma
splitOnComma :: String -> [String]
splitOnComma [] = [""]
splitOnComma (c:cs)
  | c == ','  = "" : rest
  | otherwise = (c : head rest) : tail rest
  where rest = splitOnComma cs

-- parse CSV line
parseClient :: String -> Client
parseClient line =
  let fields = splitOnComma line
  in case fields of
       [fn, ln, bal, inc, itype, mother, father, debt, alone, ageStr, jobStr, maritalStr, childrenStr, cityStr] ->
         Client fn ln (read bal) (read inc) itype (toBool mother) (toBool father)
                (toBool debt) (toBool alone) (read ageStr) jobStr maritalStr (read childrenStr) cityStr
       _ -> error ("Invalid CSV format: " ++ line)

-- read clients
readClients :: FilePath -> IO [Client]
readClients path = do
  content <- readFile path
  let ls = lines content
  return (map parseClient (drop 1 ls))

-- decision category with special rules
decisionCategory :: Client -> Category
decisionCategory c
  | age c < 18 = Rejected
  | isInDebt c = Rejected
  | (isMother c || isFather c) && children c > 0 && income c >= 1500 = Approved
  | livesAlone c && income c >= 2500 && balance c >= 1000 = Approved
  | age c > 65 && balance c >= 3000 = Approved
  | incomeType c == "variable" && balance c >= 1500 && income c >= 2000 = Approved
  | marital c == "married" && children c > 0 && income c >= 1800 = Approved
  | balance c > 1000 && income c > 2000 = Approved
  | balance c > 800 || income c > 1800 = Pending 
  | otherwise = Rejected

-- reason for decision
decisionReason :: Client -> String
decisionReason c =
  case decisionCategory c of
    Approved -> "Approved: meets special or general conditions."
    Pending  -> "Pending: borderline case, requires manual review."
    Rejected
      | age c < 18       -> "Rejected: underage."
      | isInDebt c       -> "Rejected: client has debts."
      | balance c <= 800 -> "Rejected: very low balance."
      | income c <= 1500 -> "Rejected: very low income."
      | otherwise        -> "Rejected: conditions not met."
