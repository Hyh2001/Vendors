# Vendors

A collection of ROS2 packages to vendor useful C++ packages into ROS2 ecosystem.

- [placo_vendor](placo_vendor/): PlaCo whole-body inverse kinematics and dynamics library.
- [unitree_sdk_vendor](unitree_sdk_vendor/): Unitree SDK2 C++ robot SDK and bundled DDS libraries.

## Select packages with the helper script

Download the small script and run it from your ROS 2 workspace root:

```sh
curl -fsSL https://raw.githubusercontent.com/Hyh2001/Vendors/main/get_vendors.sh -o /tmp/get_vendors.sh
bash /tmp/get_vendors.sh unitree_sdk_vendor
```

To select multiple packages:

```sh
bash /tmp/get_vendors.sh placo_vendor unitree_sdk_vendor
```

The script creates a shallow, partial clone in `src/Vendors`, checks out only
the selected package directories and top-level files, and prints the `rosdep`
command to install their dependencies.

Use `--directory PATH` to choose another checkout location. Rerunning selects
exactly the packages named, so include every package you want to keep checked
out. Existing checkouts must have no local changes and keep their current
revision; update with `git -C src/Vendors pull` when needed.

If you already cloned this repository, run the helper directly from your
workspace root:

```sh
bash src/Vendors/get_vendors.sh unitree_sdk_vendor
```

Run `bash /tmp/get_vendors.sh --help` for all options.

## Install dependencies

With ROS sourced, run the `rosdep` command printed by the helper script. For
example, to install dependencies for Unitree SDK2:

```sh
rosdep install --from-paths src/Vendors/unitree_sdk_vendor --ignore-src -r -y
```

For multiple packages, list their directories after `--from-paths`:

```sh
rosdep install --from-paths src/Vendors/placo_vendor src/Vendors/unitree_sdk_vendor --ignore-src -r -y
```
