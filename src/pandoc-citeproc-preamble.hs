import           Data.List        (isPrefixOf)
import           System.Directory (doesFileExist)
import           System.FilePath  ((<.>), (</>))
import           System.Process   (readProcess)
import           Text.Pandoc.JSON

insertPreamble :: Block -> [Block] -> [Block]
insertPreamble preamble = foldr step []
  where
    step refs@(Div (_, ["references"], _) _) xs = preamble : refs : xs
    step x xs = x:xs

doPreamble :: Maybe Format -> Pandoc -> IO Pandoc
doPreamble maybeFormat input@(Pandoc meta blocks) =
    findPreambleFile format meta
    >>= maybe (return input)
    (\file -> do
          ls <- readFile file
          return $ Pandoc meta (insertPreamble (lsBlock ls) blocks))
  where
    lsBlock ls = RawBlock format ls
    format = maybe (Format "latex") id maybeFormat

findPreambleFile    :: Format -> Meta -> IO (Maybe FilePath)
findPreambleFile (Format format) meta =
    case lookupMeta "citeproc-preamble" meta >>= toPath of
        metadataPreamble@(Just _) -> return metadataPreamble
        Nothing                   -> tryDatadir
  where
    defaultPreamble = (</> "citeproc-preamble" </> "default" <.> format)
                      <$> getPandocDatadir
    tryDatadir      = defaultPreamble >>= doesFileExist >>= \exists ->
        if exists then Just <$> defaultPreamble else return Nothing

getPandocDatadir :: IO FilePath
getPandocDatadir =
    drop (length prefix) . head . filter (prefix `isPrefixOf`) . lines
    <$> readProcess "pandoc" ["--version"] ""
  where
    prefix = "Default user data directory: "

toPath                :: MetaValue -> Maybe String
toPath (MetaString s) = Just s
toPath _              = Nothing

main :: IO ()
main = toJSONFilter doPreamble
