#!/usr/bin/env python3

import argparse
from databricks.sdk import WorkspaceClient


def get_permissions(client: WorkspaceClient, object_type: str, object_id: str) -> None:
    permissions = client.permissions.get(request_object_type=object_type, request_object_id=object_id)
    print(permissions)


def set_permissions(
    client: WorkspaceClient, object_type: str, object_id: str, principal: str, permission_level: str
) -> None:
    permissions = client.permissions.set(
        request_object_type=object_type,
        request_object_id=object_id,
        access_control_list=[{"group_name": principal, "permission_level": permission_level}],
    )
    print(permissions)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Databricks permissions SDK examples")
    subparsers = parser.add_subparsers(dest="command", required=True)

    get_parser = subparsers.add_parser("get")
    get_parser.add_argument("object_type")
    get_parser.add_argument("object_id")

    set_parser = subparsers.add_parser("set")
    set_parser.add_argument("object_type")
    set_parser.add_argument("object_id")
    set_parser.add_argument("principal")
    set_parser.add_argument("permission_level")

    return parser


def main() -> None:
    args = build_parser().parse_args()
    client = WorkspaceClient()

    if args.command == "get":
        get_permissions(client, args.object_type, args.object_id)
    elif args.command == "set":
        set_permissions(client, args.object_type, args.object_id, args.principal, args.permission_level)


if __name__ == "__main__":
    main()