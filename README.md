# Coder AUR package

This is the AUR package to build the [Coder](https://coder.com/) binaries from source.

## Packages produced

There are 4 possible packages to be produced by this PKGBUILD. See the "Configuration" heading for explanation on how to build each.

* `coder`: Enterprise monolithic server/client binary.
* `coder-oss`: AGPLv3 monolithic server/client binary.
* `coder-agent`: Enterprise slim binary - agent service for Coder-managed instances
* `coder-oss-agent`: AGPLv3 slim binary - agent service for Coder-managed instances

## Configuration

### Updating the version number

Run the `update_version.sh` script to automatically query GitHub's API for the latest tag and update the `PKGBUILD` with this version number and the correct checksums.

### License - AGPLv3 (OSS) vs. Enterprise binaries

As committed, the PKGBUILD produces AGPLv3-licensed binaries which may be distributed freely.

If you need to build Coder with enterprise features enabled, change the `license` field to `('Proprietary')`. If you are an enterprise user, please contact your account manager for guidance as to how to distribute built binaries within your organization. Distributing enterprise binaries publicly is a violation of Coder's license terms.

### `coder-agent`/`coder-oss-agent` packages

As committed, the PKGBUILD does not produce the "slim" binaries. These are not useful to the vast majority of users - they are only used on Coder-managed instances to report up to the management server for idle detection and other agent-side features.

To enable building these, change the `_package_agent` variable to `1`.

