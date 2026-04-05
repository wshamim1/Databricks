#!/usr/bin/env python3

import argparse
from databricks.sdk import WorkspaceClient


def list_repos(client: WorkspaceClient) -> None:
    for repo in client.repos.list():
        print(repo.id, repo.path, repo.url)


def create_repo(client: WorkspaceClient, path: str, url: str, provider: str) -> None:
    repo = client.repos.create(path=path, url=url, provider=provider)
    print(repo.id)


def update_branch(client: WorkspaceClient, repo_id: int, branch: str) -> None:
    repo = client.repos.update(repo_id=repo_id, branch=branch)
    print(repo.id, repo.branch)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Databricks repos SDK examples")
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("list")

    create_parser = subparsers.add_parser("create")
    create_parser.add_argument("path")
    create_parser.add_argument("url")
    create_parser.add_argument("provider")

    update_parser = subparsers.add_parser("update-branch")
    update_parser.add_argument("repo_id", type=int)
    update_parser.add_argument("branch")

    return parser


def main() -> None:
    args = build_parser().parse_args()
    client = WorkspaceClient()

    if args.command == "list":
        list_repos(client)
    elif args.command == "create":
        create_repo(client, args.path, args.url, args.provider)
    elif args.command == "update-branch":
        update_branch(client, args.repo_id, args.branch)


if __name__ == "__main__":
    main()