- [x] Use rootless podman
- [ ] Use netavark for very close to rootful networking
- [ ] Set home directory for immich-user to /var/lib/immich on some permanent mount, then the images on a separate mount symlinked into home
- [ ] Set immich-user sub(uid + gid)
- [ ] 
https://github.com/containers/podman/blob/main/docs/tutorials/basic_networking.md

podman system reset
WARNING! This will remove:
        - all containers
        - all pods
        - all images
        - all networks
        - all build cache
        - all machines
        - all volumes
        - the graphRoot directory: /var/lib/containers/storage
        - the runRoot directory: /run/containers/storage