---
title: 'Atlas'
description: 'My homelab hobby cluster: four Proxmox hosts with a HA K3s control plane, self-hosted Gitea + Argo CD GitOps, SealedSecrets, and gitleaks-guarded history — the substrate every 211 Lab experiment deploys on.'
heroImage: '../../../public/project/atlas.svg'
relatedPosts: ['atlas']
---

**Atlas** is the 211 Lab's homelab hobby cluster: a four-host Proxmox VE setup carrying a highly available K3s control plane, run with production-grade GitOps discipline.

**[Source on GitHub](https://github.com/211lab/atlas)**

## Highlights

- **HA Kubernetes on Proxmox:** three embedded-etcd control-plane VMs + one worker behind a kube-vip API VIP; Ansible-provisioned cloud-init VMs, maintenance playbooks, and a three-layer access model.
- **Self-hosted delivery loop:** Gitea forge + built-in registry + Actions runner on-cluster, with Argo CD app-of-apps reconciling Helm values — the build job writes new image tags back to git, so a commit is the deploy signal, audit log, and rollback point.
- **Secrets done right:** SealedSecrets ciphertext in the repo (sealed key never committed), gitleaks as a local pre-commit hook *and* full-history CI scan; tailnet identities excluded by policy.
- **Storage and networking:** TrueNAS NFS via CSI StorageClass; dedicated Ansible-provisioned Pi-hole with ExternalDNS auto-registering every Ingress.
- **Documented like production:** C4 architecture diagrams (verified against the live cluster), control-plane and GitOps runbooks, recovery procedures, and an opencode agent skill that onboards a new app end to end.
