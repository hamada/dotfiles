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
            # basenameにpatternが含まれればmatch
            # matched_candidates = [x for x in candidates
                          # if pattern in basename(x['word'].lower())]

            # patternを正規表現として扱い、正規表現にmatchしたものを返す
            try:
                # 入力を正規表現に変換
                p = re.compile(pattern, flags=re.IGNORECASE)
            except Exception:
                return []
            matched_candidates = [x for x in candidates if p.search(basename(x['word'].lower()))]
        else:
            matched_candidates = [x for x in candidates if pattern in basename(x['word'])]

        return matched_candidates
        # マッチしたものをマッチ率が高いもの順に並び替えして返す (なんか並び替わってるけどうまく行ってないかも？要確認)
        # return sorted(matched_candidates, key=lambda candidate: -(len(basename(candidate['word']))))
        # return sorted(matched_candidates, key=lambda candidate: -(len(re.search(pattern, basename(candidate['word'])).group(0))/len(basename(candidate['word']))))

    def convert_pattern(self, input_str: str) -> str:
        return '|'.join([re.escape(x) for x in split_input(input_str)])
