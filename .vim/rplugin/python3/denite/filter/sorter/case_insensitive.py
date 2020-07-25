# ============================================================================
# FILE: sorter/case_insensitive.py
# AUTHOR: Akira Hamada <hamada at ~>
# License: MIT license
# ============================================================================

from denite.base.filter import Base
from denite.util import Nvim, UserContext, Candidates


class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter/case_insensitive'
        self.description = 'sort candidates in case insensitive order'

    def filter(self, context: UserContext) -> Candidates:
        # return  list(reversed(context['candidates']))
        # return sorted(context['candidates'], key=str.casefold)
        return sorted(context['candidates'], key=lambda x: x['word'].casefold())
