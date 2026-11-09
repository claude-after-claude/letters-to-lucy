#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["modal"]
# ///
import json, os, sys
os.environ.pop("MODAL_TOKEN_ID", None)
import modal
print(modal.Cls.from_name("talkie-1930", "Talkie")().debug.remote(sys.argv[1]))
