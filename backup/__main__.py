#!/usr/bin/env python3
import argparse
import toml

from commands.bootstrap import on_bootstrap
from commands.create import on_create

def main():
    parser = argparse.ArgumentParser(prog='backup', description='Lukas\' backup solution')
    parser.add_argument('--config', type=argparse.FileType(), default='backup.toml')
    subparsers = parser.add_subparsers()

    parser_bootstrap = subparsers.add_parser('bootstrap', help='bootstrap help')
    parser_bootstrap.set_defaults(func=on_bootstrap)

    parser_create = subparsers.add_parser('create', help='create help')
    parser_create.set_defaults(func=on_create)

    parser_extract = subparsers.add_parser('extract', help='extract help')

    parser_test = subparsers.add_parser('test', help='test help')

    args = parser.parse_args()

    config = toml.loads(args.config.read())
    args.func(config, args)

if __name__ == '__main__':
    main()