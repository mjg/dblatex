#
# Basic module compiling a file with LaTeX
#
import os
import re
import shutil

from grubber.texbuilder import LatexBuilder


class RunLatex:
    def __init__(self):
        self.fig_paths = []
        self.verbose = 1
        self.index_style = ""
        self.backend = "pdftex"
        self.texer = LatexBuilder()

    def set_fig_paths(self, paths):
        # Assume the paths are already absolute
        # Unixify the paths when under Windows
        if paths and os.sep != "/":
            paths = [p.replace(os.sep, "/") for p in paths]

        # Protect from tilde active char (maybe others?)
        self.fig_paths = [p.replace("~", r"\string~") for p in paths]

    def set_backend(self, backend):
        if not(backend in ("dvips", "pdftex")):
            raise ValueError("'%s': invalid backend" % backend)
        self.backend = backend

    def compile(self, texfile, binfile, format, batch=1):
        root = os.path.splitext(texfile)[0]
        tmpbase = root + "_tmp"
        tmptex = tmpbase + ".tex"
        tmplog = tmpbase + ".log"
        tmpout = tmpbase + "." + format

        # The temporary file contains the extra paths
        f = file(tmptex, "w")
        if self.fig_paths:
            paths = "{" + "//}{".join(self.fig_paths) + "//}"
            f.write("\\makeatletter\n")
            f.write("\\def\\input@path{%s}\n" % paths)
            f.write("\\makeatother\n")

        # Copy the original file
        input = file(texfile)
        for line in input:
            f.write(line)
        f.close()
        input.close()

        # Build the output file
        try:
            self.texer.set_format(format)
            self.texer.set_backend(self.backend)
            if self.index_style:
                self.texer.set_index_style(self.index_style)
            self.texer.compile(tmptex)
        except:
            # On error, dump the log errors and raise again
            self.texer.print_errors()
            raise

        shutil.move(tmpout, binfile)

    def clean(self):
        self.texer.clean()
 
