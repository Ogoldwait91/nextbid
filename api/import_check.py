import sys, importlib
print("sys.path[0] =", sys.path[0])
try:
    importlib.import_module("app.main")
    print("Imported app.main OK.")
except Exception as e:
    print("IMPORT ERROR:", repr(e))
    raise
