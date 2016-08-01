# autopilot-base

Autopilot Pattern implementation Alpine base image with Consul and Containerpilot

Version 0.1.2

## Resources
Key     | Description
--------|------------
builds  | [prato/autopilot-base](https://hub.docker.com/r/prato/autopilot-base/ "Docker Hub")
webhook | are triggered by webhook upon push, named for version string, minus the 'v'.
regex   | /^v([0-9.]+)$/
tag     | {\1}
doc     | [Joyent](https://www.joyent.com/blog/applications-on-autopilot "Tim Gross")

## Updating
```bash
# needs scipting
git add .
git commit -am "trigger build"
git tag
git tag vx.y.z
git push --follow-tags
# or just set push.followTags first:
git config --local push.followTags true
```
## Configuration
```bash
echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

ls -R /usr/local
/usr/local:
app    bin    etc    lib    share

/usr/local/app:

/usr/local/bin:

/usr/local/etc:

/usr/local/lib:

/usr/local/share:

```
