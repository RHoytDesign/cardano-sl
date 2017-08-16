{-# LANGUAGE TypeFamilies #-}

module Pos.Slotting.MemState.Class
       ( MonadSlotsData (..)
       ) where

import           Control.Monad.Trans (MonadTrans)
import           Universum

import           Pos.Core.Types      (EpochIndex, Timestamp)
import           Pos.Slotting.Types  (EpochSlottingData)


-- | 'MonadSlotsData' provides access to data necessary for slotting to work.
-- Both _current_ and _next_ epoch @SlottingData@ need to be present since it's impossible
-- to create @SlottingData@ without them.
class Monad m => MonadSlotsData m where

    getSystemStartM :: m Timestamp

    getAllEpochIndicesM :: m [EpochIndex]

    getCurrentNextEpochIndexM :: m (EpochIndex, EpochIndex)

    getCurrentNextEpochSlottingDataM :: m (EpochSlottingData, EpochSlottingData)

    getEpochSlottingDataM :: EpochIndex -> m (Maybe EpochSlottingData)

    putEpochSlottingDataM :: EpochIndex -> EpochSlottingData -> m ()

    waitCurrentEpochEqualsM :: EpochIndex -> m ()


instance {-# OVERLAPPABLE #-}
    (MonadSlotsData m, MonadTrans t, Monad (t m)) =>
        MonadSlotsData (t m) where

    getSystemStartM = lift getSystemStartM

    getAllEpochIndicesM = lift getAllEpochIndicesM

    getCurrentNextEpochIndexM = lift getCurrentNextEpochIndexM

    getCurrentNextEpochSlottingDataM = lift getCurrentNextEpochSlottingDataM

    getEpochSlottingDataM = lift . getEpochSlottingDataM

    putEpochSlottingDataM = lift ... putEpochSlottingDataM

    waitCurrentEpochEqualsM = lift . waitCurrentEpochEqualsM

