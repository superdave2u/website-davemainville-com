---
title: 'Atlas: The Homelab Cluster Where Everything Else Gets Deployed'
description: 'My hobby cluster: four Proxmox hosts carrying a HA K3s control plane, with self-hosted Gitea, Actions, and Argo CD running the same GitOps discipline I expect at work — sealed secrets, gitleaks on every commit, and C4 docs that keep it honest.'
pubDate: 'Oct 04 2026'
heroImage: '/project/atlas.svg'
tags: ['home-lab', 'kubernetes', 'gitops']
---

Every experiment on this blog eventually needs somewhere to run. [Atlas](https://github.com/211lab/atlas) is that somewhere — my homelab hobby cluster, the substrate the 211 Lab builds on: a **four-host Proxmox VE cluster carrying a highly available K3s control plane**, operated with the same GitOps discipline I'd demand in an enterprise environment.

## Named in homage

I've been fortunate enough to be around computers for nearly 30 years now, starting as a young child, and between my gaming computer and this cluster I've always felt myself connected to computer science. So every device I keep is named in homage to somebody notable from its history — the naming is written into the [211 Lab organization profile](https://github.com/211lab) like a little family tree:

- **Atlas** — the cluster itself. Not a person, but the 1960s British supercomputer from the University of Manchester, Ferranti, and Plessey — among the first machines with virtual memory and real multitasking support, and deeply influential in early OS design. A name for the machine everything else runs *on*.
- **Titan** — my gaming workstation, named for the Oak Ridge National Laboratory Cray supercomputer (2012–2019) that was among the first to pair CPUs and GPUs at scale. It earned its name twice over: it's the machine whose GPU (the RTX 3090) powers my local-model research.
- **Turing** (10.0.0.101, control plane 1) — Alan Turing, the father of theoretical computer science: the Turing machine, the concept of the algorithm, the Enigma break.
- **Hopper** (10.0.0.102, control plane 2) — Grace Hopper, the compiler pioneer: high-level programming, COBOL, and the popularized art of "debugging."
- **Lovelace** (10.0.0.103, control plane 3) — Ada Lovelace, who wrote the first algorithm intended to be executed by a machine — and saw that machines could go beyond arithmetic.
- **Babbage** (10.0.0.104, the worker) — Charles Babbage, who designed the Difference Engine and proposed the Analytical Engine.

There's an unintentional joke in the topology I only noticed after the fact: the **three hosts carrying the control plane — the nodes that deliberate and keep state — are the theorists and programmers** (Turing, Hopper, Lovelace), while **Babbage, the man who actually built machines, carries the worker doing the physical execution**. The homelab reenacted the Analytical Engine's division of labor without anyone planning it.

## The shape of the cluster

Four physical Proxmox hosts carry the K3s VMs: **three embedded-etcd control-plane nodes and one worker**, fronted by a **kube-vip** virtual IP so the Kubernetes API has a stable address. Storage comes from a dedicated **TrueNAS NFS dataset** wired through the NFS CSI driver as a StorageClass. Networking is handled by a **dedicated Pi-hole**, provisioned by Ansible, that automatically registers every cluster Ingress as a DNS entry (ExternalDNS) — so `git.atlas.lan`, `registry.atlas.lan`, and `argocd.atlas.lan` simply exist once things deploy. Observability covers both layers: kube-prometheus-stack (Prometheus + Grafana) watches the K3s VMs *and* scrapes node exporters running on all four Proxmox hosts themselves.

The provisioning path is Ansible end to end — a bootstrap playbook for the control user, cloud-init Ubuntu VMs, package-maintenance playbooks, and DNS sync. The repo keeps a three-layer access model explicit (Proxmox root / guest OS / Kubernetes admin) with the rule that a credential for one layer never substitutes for the next.

## The GitOps platform

The fun part: the cluster hosts its **own delivery system**. A self-hosted **Gitea** forge (with bundled PostgreSQL) and its built-in container registry run on the cluster, with a Gitea Actions runner building images via act_runner + DinD. **Argo CD** (app-of-apps) reconciles everything from Helm values stored in the repo's `gitops/` tree.

The clever seam is image promotion: Argo CD core has no registry poller, so **the build job itself writes the new image tag back to git** — the commit is the deployment signal, the audit log, and the rollback point in one. Secrets are handled by **SealedSecrets**: encrypted ciphertext lives in the repo under `gitops/sealed/`, decryptable only inside the cluster by the controller's key; the sealing private key is never committed.

## Documentation as an operating habit

What I'm proudest of isn't the YAML — it's that the cluster is *documented like production*. A [C4 architecture document](https://github.com/211lab/atlas/blob/main/docs/c4-architecture.md) maps the whole platform (Context → Container → Component → Deployment) with Mermaid diagrams, verified against the live system. Runbooks cover the control plane, the GitOps platform, Pi-hole provisioning with rollback steps, and recovery procedures. The README keeps honest lab notes — corosync cert restarts after node changes, removing a host from quorum wait so a critical service boots unattended. And there's an **opencode agent skill** (`.opencode/skills/atlas-deploy-app`) that onboards a new application end to end — add the `atlas` remote, create the Gitea repo, wire CI secrets, commit the Helm chart and Argo CD Application, tag a release, verify the build-and-deploy.

## Security posture

Secrets are guarded by **gitleaks in two places**: a tracked pre-commit hook locally, and a CI workflow that scans the **full history** on every push. The threat model is written down: internal `10.0.0.0/8` addresses and `*.atlas.lan` names are intentionally public — tailnet identities are not. My own independent scan of all 64 commits before publishing this post confirmed it: the only credential-shaped material in the entire history is sealed ciphertext.

## What it taught me

The homelab is where discipline gets *earned* rather than imposed. Nothing here is production, and that's the point — the failure modes are real (etcd quorum, NFS mounts, DNS propagation) but the blast radius is friendly, so I can hold myself to enterprise standards: GitOps as the only way in, secrets never in plaintext, docs that survive a month away from the cluster. Every other project in this blog stands on it; a few of them are deployed by it. The best hobby cluster isn't the biggest one — it's the one boring enough to trust.
