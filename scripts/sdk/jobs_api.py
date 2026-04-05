#!/usr/bin/env python3

import argparse
from databricks.sdk import WorkspaceClient


def create_job(client: WorkspaceClient) -> None:
    job = client.jobs.create(
        name="orders_daily_pipeline",
        max_concurrent_runs=1,
        tasks=[
            {
                "task_key": "ingest_orders",
                "notebook_task": {
                    "notebook_path": "/Workspace/Shared/notebooks/ingest_orders",
                    "base_parameters": {
                        "run_date": "2026-04-04",
                        "run_mode": "incremental",
                    },
                },
                "new_cluster": {
                    "spark_version": "15.4.x-scala2.12",
                    "node_type_id": "Standard_DS3_v2",
                    "num_workers": 2,
                },
            }
        ],
    )
    print(job.job_id)


def list_jobs(client: WorkspaceClient) -> None:
    for job in client.jobs.list():
        name = job.settings.name if job.settings else "<unknown>"
        print(job.job_id, name)


def run_job(client: WorkspaceClient, job_id: int) -> None:
    run = client.jobs.run_now(
        job_id=job_id,
        job_parameters={"run_date": "2026-04-04"},
    )
    print(run.run_id)


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Databricks jobs SDK examples")
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("create")
    subparsers.add_parser("list")
    run_parser = subparsers.add_parser("run")
    run_parser.add_argument("job_id", type=int)
    return parser


def main() -> None:
    args = build_parser().parse_args()
    client = WorkspaceClient()

    if args.command == "create":
        create_job(client)
    elif args.command == "list":
        list_jobs(client)
    elif args.command == "run":
        run_job(client, args.job_id)


if __name__ == "__main__":
    main()