"""Customize Python Interactive Console

This python startup customization will try to enable certain 3rd party
features if they are available, across all platforms.

  * If the `rich` library is available, some of its features will be enabled
    such as the pretty printer, traceback printing, and inspect function
  * If `ipython` is available, it will be used as the interpreter
  * If `prompt_toolkit` is available, it will be used as the interpreter
  * Otherwise, if readline is available it will be used

Sources/Inspiration:
    - site.rlcompleter.register_readline
    - prompt_toolkit help documentation / samples
"""

LOCALS = {}
# Use the rich library if available, make rich.inspect available
try:
    from rich import pretty, inspect, traceback as tb
    pretty.install()
    tb.install(show_locals=False)
    LOCALS['inspect'] = inspect
    del tb, pretty
except ImportError:
    pass

# Use IPython as interactive interpreter if available
try:
    import IPython
    import os

    os.environ["PYTHONSTARTUP"] = ""
    IPython.start_ipython(user_ns=LOCALS)
    raise SystemExit
except ImportError:
    pass

class CustomInitialization:
    @staticmethod
    def init_histfile():
        import os
        from pathlib import Path

        # Adapted from https://bugs.python.org/msg318437
        if "PYTHONHISTFILE" in os.environ:
            hist = os.environ["PYTHONHISTFILE"]
        elif "XDG_DATA_HOME" in os.environ:
            hist = Path(os.environ["XDG_DATA_HOME"]) / "python" / "python_history"
        else:
            hist = Path("~/.python_history")
        
        history = Path(hist).expanduser().absolute()
        history.parent.mkdir(parents=True, exist_ok=True)
        history.touch(exist_ok=True)

        return history
    
    @staticmethod
    def init_readline_completion():
        try:
            import readline
            import rlcompleter  # noqa: F401
        except ImportError:
            return

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

    @staticmethod
    def init_readline_history(cls):
        try:
            import readline
        except ImportError:
            return
        import atexit
        
        cls.init_readline_completion()
        history = cls.init_histfile()
        readline.read_history_file(history)

        def write_history():
            try:
                readline.write_history_file(history)
            except OSError:
                # bpo-19891, bpo-41193: Home directory does not exist
                # or is not writable, or the filesystem is read-only.
                pass

        atexit.register(write_history)


# The following checks for prompt_toolkit / pygments, to use as an
# alternative to readline.
try:
    from prompt_toolkit import PromptSession
    from prompt_toolkit.history import FileHistory
    from prompt_toolkit.auto_suggest import AutoSuggestFromHistory
    try:
        from pygments.lexers.python import PythonLexer
        from pygments.styles import get_style_by_name
        from prompt_toolkit.lexers import PygmentsLexer
        from prompt_toolkit.styles.pygments import style_from_pygments_cls
        style = style_from_pygments_cls(get_style_by_name('onedark'))
        lexer = PygmentsLexer(PythonLexer)
    except ImportError:
        lexer = None
        style = None
    from functools import partial
    import code

    history = CustomInitialization.init_histfile()
    session = PromptSession(history=FileHistory(history))
    custom_prompt = partial(
        session.prompt,
        auto_suggest=AutoSuggestFromHistory(),
        lexer=lexer,
        style=style,
        include_default_pygments_style=False
    )
    code.interact(readfunc=custom_prompt, banner="", locals=LOCALS)
    raise SystemExit
except ImportError:
    pass

import sys  # noqa


sys.__interactivehook__ = CustomInitialization.init_readline_history
del sys, LOCALS, CustomInitialization
