#!/usr/bin/env python3

import argparse
from databricks.sdk import WorkspaceClient


def list_workspace(client: WorkspaceClient, path: str) -> None:
    for obj in client.workspace.list(path):
        print(obj.path, obj.object_type)


def mkdirs_workspace(client: WorkspaceClient, path: str) -> None:
    client.workspace.mkdirs(path)
    print(path)


def delete_workspace(client: WorkspaceClient, path: str) -> None:
    client.workspace.delete(path=path, recursive=True)
    print(path)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Databricks workspace SDK examples")
    subparsers = parser.add_subparsers(dest="command", required=True)

    list_parser = subparsers.add_parser("list")
    list_parser.add_argument("path", nargs="?", default="/Workspace")

    mkdirs_parser = subparsers.add_parser("mkdirs")
    mkdirs_parser.add_argument("path")

    delete_parser = subparsers.add_parser("delete")
    delete_parser.add_argument("path")

    return parser


def main() -> None:
    args = build_parser().parse_args()
    client = WorkspaceClient()

    if args.command == "list":
        list_workspace(client, args.path)
    elif args.command == "mkdirs":
        mkdirs_workspace(client, args.path)
    elif args.command == "delete":
        delete_workspace(client, args.path)


if __name__ == "__main__":
    main()