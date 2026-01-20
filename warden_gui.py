#!/usr/bin/env python3
"""WardenGUI - Run directly from root directory."""
import os
import sys

# Add src to path
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), 'src'))

from wardengui.cli import main

if __name__ == "__main__":
    main()
