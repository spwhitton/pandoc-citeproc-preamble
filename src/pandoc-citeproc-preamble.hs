import           Text.Pandoc.JSON

preamble = [ RawBlock (Format "latex") "\\section*{References}"
           , Para [ RawInline (Format "tex") "\\setlength{\\parindent}{-0.2in}"
                  , Space
                  , RawInline (Format "tex") "\\setlength{\\leftskip}{0.2in}"
                  , Space
                  , RawInline (Format "tex") "\\setlength{\\parskip}{8pt}"
                  , Space
                  , RawInline (Format "tex") "\\vspace*{-0.2in}"
                  , Space
                  , RawInline (Format "tex") "\\noindent"
                  ]
           ]

insertPreamble :: [Block] -> [Block]
insertPreamble = foldr step []
  where
    step refs@(Div (_, ["references"], _) _) xs = preamble ++ refs : xs
    step x xs = x:xs

main = toJSONFilter preamble
  where
    preamble (Pandoc meta blocks) = Pandoc meta (insertPreamble blocks)
