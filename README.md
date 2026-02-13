# Logan

**Parse and analyze IIS and S3 access logs with SQL.**

Logan is a fast, cross-platform CLI that parses IIS W3C Extended and AWS S3 Server Access Log files into Parquet format, then lets you query them with SQL. Parsed logs are cached as Parquet files, so subsequent queries are instant.

## Supported Log Formats

- **IIS W3C Extended Log Format** — auto-detected from `#Fields:` directives or date-prefixed lines
- **AWS S3 Server Access Logs** — auto-detected from the 64-character hex bucket owner ID

## Installation

### Download a binary

Grab the latest release for your platform from the [Releases page](https://github.com/wagneripjr/logan-pub/releases/latest).

| Platform | Architecture | Binary |
|----------|-------------|--------|
| Linux | x86_64 (amd64) | `logan-linux-amd64` |
| Linux | aarch64 (arm64) | `logan-linux-arm64` |
| macOS | Apple Silicon (arm64) | `logan-darwin-arm64` |
| Windows | x86_64 (amd64) | `logan-windows-amd64.exe` |

### Quick install (Linux / macOS)

```bash
curl -fsSL https://wagneripjr.github.io/logan-pub/install.sh | sh
```

## Quick Start

```bash
# Parse and show log summary
logan -s access.log info

# Top 20 endpoints from a directory (recursive)
logan -s /var/log/iis/ -r top 20

# Analyze S3 access logs directly from a bucket
logan -s "s3://my-bucket/logs/" top 10

# Run custom SQL
logan -s access.log sql "SELECT client_ip, COUNT(*) as n FROM logs GROUP BY 1 ORDER BY 2 DESC LIMIT 10"

# Show errors with local timezone
logan -s access.log --local errors
```

## Commands

| Command | Description |
|---------|-------------|
| `parse` | Parse log file(s) into Parquet format |
| `top` | Show top endpoints by request count |
| `slow` | Show slowest endpoints by average response time |
| `errors` | Show endpoints with most errors (4xx/5xx) |
| `clients` | Show top clients by request count |
| `hourly` | Show request counts per hour |
| `daily` | Show request counts per day |
| `sql` | Execute custom SQL query against log data |
| `info` | Show metadata about parsed log data |
| `schema` | Show table name and available columns |

## Global Options

| Option | Description |
|--------|-------------|
| `-s, --source <PATH>` | Path to log file, directory, or S3 URI (`s3://bucket/prefix/`) |
| `-r, --recursive` | Recursively search subdirectories for log files |
| `-v, --verbose` | Show parsing progress |
| `-o, --output <PATH>` | Output Parquet file path (default: `logs.parquet`) |
| `--hash` | Use content hash for cache validation (instead of mtime) |
| `--force` | Force re-download and re-parse (ignore cache) |
| `-f, --format <FORMAT>` | Log format: `auto`, `iis`, or `s3` (default: `auto`) |
| `--local` | Use system local timezone for display |
| `--tz <TZ>` | Timezone name (e.g., `America/Sao_Paulo`) |

## License

Copyright (c) 2026 Adustio. All rights reserved.

This software is proprietary. See [LICENSE](LICENSE) for details.
