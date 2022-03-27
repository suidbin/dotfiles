"""Customize Python Startup

The bulk of this startup customization is copied from the default interactive
hook set at site.rlcompleter.register_readline. It is customized to respect
PYTHONHISTFILE and XDG_DATA_HOME if set for placing the history file.
"""
import sys


def custom_register_readline():
    try:
        import readline
        import rlcompleter  # noqa: F401
    except ImportError:
        return
    import atexit
    import os

    # Reading the initialization (config) file may not be enough to set a
    # completion key, so we set one first and then read the file.
    readline_doc = getattr(readline, "__doc__", "")
    if readline_doc is not None and "libedit" in readline_doc:
        readline.parse_and_bind("bind ^I rl_complete")
    else:
        readline.parse_and_bind("tab: complete")

    try:
        readline.read_init_file()
    except OSError:
        # An OSError here could have many causes, but the most likely one
        # is that there's no .inputrc file (or .editrc file in the case of
        # Mac OS X + libedit) in the expected location.  In that case, we
        # want to ignore the exception.
        pass

    # Adapted from https://bugs.python.org/msg318437
    if "PYTHONHISTFILE" in os.environ:
        history = os.path.expanduser(os.environ["PYTHONHISTFILE"])
    elif "XDG_DATA_HOME" in os.environ:
        history = os.path.join(os.path.expanduser(os.environ["XDG_DATA_HOME"]),
                               "python", "python_history")
    else:
        history = os.path.join(os.path.expanduser("~"), ".python_history")

    history = os.path.abspath(history)
    _dir, _ = os.path.split(history)
    os.makedirs(_dir, exist_ok=True)

    try:
        readline.read_history_file(history)
    except IOError:
        pass

    def write_history():
        try:
            readline.write_history_file(history)
        except OSError:
            # bpo-19891, bpo-41193: Home directory does not exist
            # or is not writable, or the filesystem is read-only.
            pass

    atexit.register(write_history)


sys.__interactivehook__ = custom_register_readline
del sys, custom_register_readline
