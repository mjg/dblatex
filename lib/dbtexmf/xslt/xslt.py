#
# Very simple plugin loader for Xslt classes
#
import os
import importlib.machinery
import importlib.util
import glob
import sys

def load(modname):
    spec = importlib.machinery.PathFinder.find_spec(modname, [""])
    if not spec:
        spec = importlib.machinery.PathFinder.find_spec(modname,
                                                        [os.path.dirname(__file__)])
    if not spec:
        raise ValueError("Xslt '%s' not found" % modname)

    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    sys.modules[modname] = mod
    o = mod.Xslt()
    return o

def get_deplists():
    """
    Return the dependency list to check for each XSLT plugin. The returned
    list also gives the available plugins.
    """
    ps = glob.glob(os.path.join(os.path.dirname(__file__), "*.py"))
    selfmod = os.path.splitext(os.path.basename(__file__))[0]
    ps = [os.path.splitext(os.path.basename(p))[0] for p in ps]
    if selfmod in ps:
        ps.remove(selfmod)
    if "__init__" in ps:
        ps.remove("__init__")

    deplists = []
    for p in ps:
        try:
            x = load(p)
            deplists.append((p, x.get_deplist()))
        except:
            # The module cannot be loaded, but don't panic yet
            pass

    return deplists
