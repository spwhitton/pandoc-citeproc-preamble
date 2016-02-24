{-

    pandoc-citeproc-preamble --- Insert a preamble before pandoc-citeproc's bibliography

    Copyright (C) 2015-2016  Sean Whitton

    This file is part of pandoc-citeproc-preamble.

    pandoc-citeproc-preamble is free software: you can redistribute it
    and/or modify it under the terms of the GNU General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    pandoc-citeproc-preamble is distributed in the hope that it will
    be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
    of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with pandoc-citeproc-preamble.  If not, see
    <http://www.gnu.org/licenses/>.

-}

import           Data.List        (isPrefixOf)
import           System.Directory (doesFileExist)
import           System.FilePath  ((<.>), (</>))
import           System.Process   (readProcess)
import           Text.Pandoc.JSON

insertPreamble :: Block -> [Block] -> [Block]
insertPreamble preamble = foldr step []
  where
    step refsDiv@(Div (_, ["references"], _) theRefs) xs =
        -- check whether pandoc-citeproc actually inserted any
        -- references
        if null theRefs
        then refsDiv : xs
        else preamble : refsDiv : xs
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

findPreambleFile :: Format -> Meta -> IO (Maybe FilePath)
findPreambleFile (Format format) meta =
    case lookupMeta "citeproc-preamble" meta >>= toPath of
        metadataPreamble@(Just _) -> return metadataPreamble
        Nothing                   -> tryDatadir
  where
    tryDatadir = do
        defaultPreamble <- (</> "citeproc-preamble" </> "default" <.> format)
                           <$> getPandocDatadir
        doesFileExist defaultPreamble >>= \exists ->
            return $ if exists then Just defaultPreamble else Nothing

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
