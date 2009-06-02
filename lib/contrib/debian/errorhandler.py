#
# Attempt to analyse a dblatex failure occured on a Debian platform.
#
# Author: Andreas Hoenen
#
import subprocess
import sys
import apt

from dbtexmf.core.error import ErrorHandler
from dbtexmf.core.imagedata import ImageConverter
from dbtexmf.core.dbtex import DbTex


class DebianHandler(ErrorHandler):
    def __init__(self):
        ErrorHandler.__init__(self)
        self.object = None

    def signal(self, failed_object, *args, **kwargs):
        self.object = failed_object
        if (isinstance(self.object, DbTex)):
            self._check_dbtexrun()
        elif (isinstance(self.object, ImageConverter)):
            self._check_imagerun(*args)

    def _check_dbtexrun(self):
        # First, check the XML input sanity
        if (self._check_input()):
            return
        # Check that all the required utilities are there
        if (self._check_dependencies()):
            return
        # Check some alternative reasons
        if (self._check_cyrillic()):
            return

    def _check_imagerun(self, cmd):
        """
        In case of failed image converter calls check on dependency problems.

        In Debian dblatex package dependencies on image converters are not
        absolute, as image conversion is not dblatex's core functionality.
        Thus the converters may be not installed.  Therefore check for each one:
        If it is used but missing, dump an appropriate hint.
        """
        aptcache = apt.Cache()
        warn_msgs = []
        if ((cmd.startswith('convert') or cmd.find('&& convert') > -1)
            and not aptcache['graphicsmagick-imagemagick-compat'].isInstalled
            and not aptcache['imagemagick'].isInstalled):
            warn_msgs.append('For image conversion one of Debian packages'
                             + ' graphicsmagick-imagemagick-compat')
            warn_msgs.append('or imagemagick is needed')
        if ((cmd.startswith('epstopdf') or cmd.find('&& epstopdf') > -1)
            and not aptcache['ghostscript'].isInstalled):
            warn_msgs.append('For image conversion Debian package ghostscript'
                             + ' is needed')
        if ((cmd.startswith('fig2dev') or cmd.find('&& fig2dev') > -1)
            and not aptcache['transfig'].isInstalled):
            warn_msgs.append('For image conversion Debian package transfig is'
                             + ' needed')
        if warn_msgs:
            print >> sys.stderr, "\n" + "\n".join(warn_msgs) + "\n"
 

    def _check_input(self):
        """
        In case of failed processing try to validate the input.

        As invalid DocBook sometimes results in strange TeX error messages, a
        hint about the failure cause may be helpful.
        Post failure validation is a convenience function and thus works in
        a best effort approach, that is it will silently skip any problems,
        e.g. the external validation program xmllint not installed.
        """
        obj = self.object
        nulldev = file('/dev/null')
        try:
            rc = subprocess.Popen(['xmllint', '--noout', '--postvalid',
                                   '--xinclude', obj.input],
                                   stdin=nulldev,
                                   stderr=nulldev,
                                   stdout=nulldev).wait()
            nulldev.close()
        except:
            nulldev.close()
            return False

        if rc == 3 or rc == 4:
            print >> sys.stderr
            print >> sys.stderr, 'A possible reason for transformation',
            print >> sys.stderr, 'failure is invalid DocBook'
            print >> sys.stderr, '(as reported by xmllint)'
            print >> sys.stderr
            return True
        else:
            return False

    def _check_dependencies(self):
        """
        In case of failed processing check on dependency problems.

        For not commonly used dblatex functionality the Debian package
        dependencies are not absolute, thus the functionality may be not
        installed.  Therefore check for each one:
        If it is used but a needed dependency is missing, dump an appropriate
        hint.
        """
        obj = self.object
        aptcache = apt.Cache()
        warn_msgs = []
        if obj.backend == 'xetex':
            for debian_pkg in 'texlive-xetex', 'lmodern':
                if not aptcache[debian_pkg].isInstalled:
                    warn_msgs.append('For xetex backend Debian package '
                                     + debian_pkg + ' is needed')
        if obj.input_format == 'sgml':
            for debian_pkg in 'docbook', 'opensp':
                if not aptcache[debian_pkg].isInstalled:
                    warn_msgs.append('For SGML documents Debian package '
                                     + debian_pkg + ' is needed')
        if obj.runtex.texer.encoding == 'utf8':
            debian_pkg = 'texlive-lang-cyrillic'
            if not aptcache[debian_pkg].isInstalled:
                warn_msgs.append('For utf8 encoding Debian package '
                                 + debian_pkg + ' is needed')
        if warn_msgs:
            print >> sys.stderr, "\n" + "\n".join(warn_msgs) + "\n"
            return True
        else:
            return False

    def _check_cyrillic(self):
        obj = self.object
        """
        In case of failed processing check on the "cyrillic scenario":

        Transforming cyrillic documents will fail when neither using the
        XeTeX backend nor setting option latex.unicode.use
        In this case a hint to XeTeX (as the preferred way) may be helpful.
        Post failure validation is a convenience function and thus works in
        a best effort approach, that is it will silently skip any problems.
        """
        # This kind of error cannot occur with backends that natively support
        # Unicode
        if obj.backend == 'xetex':
            return False

        try:
            for log_entry in obj.runtex.texer.tex.log.get_errors():
                if (log_entry['text']
                    == r'Undefined control sequence \cyrchar.'):
                    print >> sys.stderr
                    print >> sys.stderr, 'Transformation failure',
                    print >> sys.stderr, 'might be caused by handling a',
                    print >> sys.stderr, 'cyrillic document'
                    print >> sys.stderr, 'without the XeTeX backend'
                    print >> sys.stderr
                    return True
        except:
            pass
        return False
