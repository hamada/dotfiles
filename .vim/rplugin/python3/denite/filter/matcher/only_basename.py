# ============================================================================
# FILE: matcher/only_basename.py
# AUTHOR: Akira Hamada <hamada at ~>
# License: MIT license
# ============================================================================

import re

from os.path import basename
from denite.base.filter import Base
from denite.util import split_input, Nvim, UserContext, Candidates


class Filter(Base):
    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'matcher/only_basename'
        self.description = 'match with only basename'

    def filter(self, context: UserContext) -> Candidates:
        candidates: Candidates = context['candidates']
        ignorecase = context['ignorecase']
        if context['input'] == '':
            return candidates

        pattern = context['input']
        if ignorecase:
            pattern = pattern.lower()
            candidates = [x for x in candidates
                          if pattern in basename(x['word'].lower())]
        else:
            candidates = [x for x in candidates if pattern in basename(x['word'])]
        return candidates

    def convert_pattern(self, input_str: str) -> str:
        return '|'.join([re.escape(x) for x in split_input(input_str)])
