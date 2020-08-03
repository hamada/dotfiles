# ============================================================================
# FILE: sorter/case_insensitive.py
# AUTHOR: Akira Hamada <hamada at ~>
# License: MIT license
# ============================================================================

from denite.base.filter import Base
from denite.util import Nvim, UserContext, Candidates
from os.path import basename

class Filter(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'sorter/case_insensitive'
        self.description = 'sort candidates in case insensitive order'

    def filter(self, context: UserContext) -> Candidates:
        # return  list(reversed(context['candidates']))
        # return sorted(context['candidates'], key=str.casefold)
        # return sorted(context['candidates'], key=lambda x: x['word'].casefold())

        for candidate in context['candidates']:
            candidate['my_sort__score'] = directory_first_sort_score(candidate)
        return sorted(context['candidates'], key=lambda x: -x['my_sort__score'])

# higher score candidate comes first
def directory_first_sort_score(candidate) -> int:
    d = {
            '.': 54,
            '-': 53,
            'A': 52,
            'B': 51,
            'C': 50,
            'D': 49,
            'E': 48,
            'F': 47,
            'G': 46,
            'H': 45,
            'I': 44,
            'J': 43,
            'K': 42,
            'L': 41,
            'M': 40,
            'N': 39,
            'O': 38,
            'P': 37,
            'Q': 36,
            'R': 35,
            'S': 34,
            'T': 33,
            'U': 32,
            'V': 31,
            'W': 30,
            'X': 29,
            'Y': 28,
            'Z': 27,
            'a': 26,
            'b': 25,
            'c': 24,
            'd': 23,
            'e': 22,
            'f': 21,
            'g': 20,
            'h': 19,
            'i': 18,
            'j': 17,
            'k': 16,
            'l': 15,
            'm': 14,
            'n': 13,
            'o': 12,
            'p': 11,
            'q': 10,
            'r': 9,
            's': 8,
            't': 7,
            'u': 6,
            'v': 5,
            'w': 4,
            'x': 3,
            'y': 2,
            'z': 1,
        }
    try:
        basename_first_letter = basename(candidate['word'])[0]
        base_score = d[basename_first_letter]

        return base_score + 1000 if candidate['kind'] == 'directory' else base_score
    except (IndexError, KeyError):
        return 1

