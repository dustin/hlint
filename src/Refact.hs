module Refact
    ( toRefactSrcSpan, toRefactSrcSpan'
    , toSS, toSS'
    , toSrcSpan'
    ) where

import qualified Refact.Types as R
import HSE.All

import qualified SrcLoc as GHC

toRefactSrcSpan :: SrcSpan -> R.SrcSpan
toRefactSrcSpan ss = R.SrcSpan (srcSpanStartLine ss)
                               (srcSpanStartColumn ss)
                               (srcSpanEndLine ss)
                               (srcSpanEndColumn ss)

toRefactSrcSpan' :: GHC.SrcSpan -> R.SrcSpan
toRefactSrcSpan' = toRefactSrcSpan . ghcSpanToHSE

toSS :: Annotated a => a S -> R.SrcSpan
toSS = toRefactSrcSpan . srcInfoSpan . ann

-- | Don't crash in case ghc gives us a \"fake\" span,
-- opting instead to show @0 0 0 0@ coordinates.
toSrcSpan' :: GHC.HasSrcSpan a => a -> R.SrcSpan
toSrcSpan' x = case GHC.getLoc x of
    GHC.RealSrcSpan span ->
        R.SrcSpan (GHC.srcSpanStartLine span)
                  (GHC.srcSpanStartCol span)
                  (GHC.srcSpanEndLine span)
                  (GHC.srcSpanEndCol span)
    GHC.UnhelpfulSpan _ ->
        R.SrcSpan 0 0 0 0

toSS' :: GHC.HasSrcSpan e => e -> R.SrcSpan
toSS' = toRefactSrcSpan' . GHC.getLoc
