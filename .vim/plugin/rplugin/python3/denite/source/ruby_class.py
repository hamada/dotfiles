# ============================================================================
# FILE: ruby_class.py
# AUTHOR: Akira Hamada <email address here>
# License: MIT license
# ============================================================================

from os import path

from denite.base.source import Base
from denite.util import globruntime, Nvim, UserContext, Candidates


class Source(Base):

    def __init__(self, vim: Nvim) -> None:
        super().__init__(vim)

        self.name = 'ruby_class'
        self.kind = 'command'

    def gather_candidates(self, context: UserContext) -> Candidates:
        methods = {}

        for method in ['foo', 'bar', 'baz', 'her']:
            methods[method] = {
                'word': method,
                'action__command': 'echo "%s is selected!"' %(method)
            }

        return sorted(methods.values(), key=lambda value: value['word'])
