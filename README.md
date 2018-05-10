# sos-monitoring-tools
Tools and scripts required by SOSETH monitoring roles. This is a work in progress,
not all tools have been packaged yet.

## Usage
You can either manually install all dependencies and do
```
./build.sh <dist>
```
or you can use the docker-based build:
```
make all
```
After a while, you should end up with a bunch of debian packages in
out-<version>, which you can then publish in some repository (or use ours).
