#!/usr/bin/env python3

import argparse

from databricks.sdk import WorkspaceClient


def create_cluster(client: WorkspaceClient) -> str:
    cluster = client.clusters.create(
        cluster_name="demo-sdk-cluster",
        spark_version="15.4.x-scala2.12",
        node_type_id="Standard_DS3_v2",
        num_workers=2,
        autotermination_minutes=20,
    )
    print(cluster.cluster_id)
    return cluster.cluster_id


def create_and_install(client: WorkspaceClient) -> None:
    cluster_id = create_cluster(client)
    client.libraries.install(
        cluster_id=cluster_id,
        libraries=[
            {"pypi": {"package": "pandas==2.2.2"}},
            {"jar": "dbfs:/FileStore/jars/example-library.jar"},
        ],
    )
    print(f"Installed sample libraries on {cluster_id}")


def list_clusters(client: WorkspaceClient) -> None:
    for cluster in client.clusters.list():
        print(cluster.cluster_id, cluster.cluster_name)


def delete_cluster(client: WorkspaceClient, cluster_id: str) -> None:
    client.clusters.delete(cluster_id=cluster_id)
    print(cluster_id)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Databricks clusters SDK examples")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("create")
    subparsers.add_parser("create-and-install")
    subparsers.add_parser("list")
    delete_parser = subparsers.add_parser("delete")
    delete_parser.add_argument("cluster_id")
    return parser


def main() -> None:
    args = build_parser().parse_args()
    client = WorkspaceClient()

    if args.command == "create":
        create_cluster(client)
    elif args.command == "create-and-install":
        create_and_install(client)
    elif args.command == "list":
        list_clusters(client)
    elif args.command == "delete":
        delete_cluster(client, args.cluster_id)


if __name__ == "__main__":
    main()