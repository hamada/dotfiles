from pathlib import Path
from os.path import split
from denite.base.filter import Base
from denite.util import path2project, path2dir, relpath

class Filter(Base):

    def __init__(self, vim):
        super().__init__(vim)

        self.name = 'converter/full_path_abbr'
        self.description = 'display full path as abbr'
        self.vars = {
            'with_word': True,
            'root_markers': ['package.json', 'composer.json']
        }

    def filter(self, context):
        for candidate in context['candidates']:
            full_path = candidate['word']
            basename = candidate['abbr']

            if Path(full_path).is_dir():
                full_path = full_path + '/'

            candidate['abbr'] = full_path
            candidate['word'] = basename
        return context['candidates']
